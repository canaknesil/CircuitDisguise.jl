# MIT License

# Copyright (c) 2024 Can Aknesil

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


module CircuitDisguise

include("Util.jl")
include("SDFParser.jl")
include("CircuitRepresentation.jl")
include("CellLibraries.jl")
include("NetlistReader.jl")
include("NetlistPreparation.jl")
include("Reports.jl")

using Reexport
import Serialization as ser

@reexport using .Util
@reexport using .CircuitRepresentation
@reexport using .CellLibraries
@reexport using .NetlistReader
@reexport using .NetlistPreparation
@reexport using .Reports


export read_netlist, disguise_design!, save_design, load_design, check_cycles, check_fanout, check_signal_connections, check_short_circuits, set_delay!, set_primary_port_delay!, set_frequency!, set_primary_input_frequency!, propagate_frequency!, check_power, check_timing!, check_design!


"Flag input ports and primary outputs with multiple drivers as short circuits."
function flag_short_circuits!(netlist::DesignNetlist)
    g = netlist.graph
    driven_ports = filter(!is_driver, vertices(g))
    for p in driven_ports
        indegree = length(incoming_edges(p))
        if indegree > 1
            p["flag_short_circuit"] = true
            #println("Short circuit detected! Port=$(p.id) indegree=$indegree")
        end
    end
end


"Flag ports according to the type of the signal they carry. Clock, asynchronous, constant, primary, or data."
function flag_ports!(netlist::DesignNetlist, lib::CellLibrary)
    cells = netlist.cells
    primary_ports = netlist.primary_ports

    for p in primary_ports
        p["signal_type"] = "primary"
    end
    
    for c in cells
        cell_type = c["type"]
        for p in ports(c)
            port_name = p["name"]
            signal_type = get_port_signal_type(lib, cell_type, port_name)
            p["signal_type"] = signal_type
        end
    end
end


function calculate_activity_factor(inputs::AbstractVector)
    # Assuming that T, the maximum number of transitions that can
    # happen at an outgoing edge when an incoming edge changes, is
    # 1. T=1 means that cells are assumed to be internally
    # glitch-free.

    if isempty(inputs)
        println("Warning: No input to calculate activity factor! Returning zero.")
        return 0
    end
    
    K = 0
    for x in inputs
        if !isnothing(x)
            K += x
        else
            println("Warning: Missing activity factor at input! Assuming as zero.")
        end
    end
    
    return K
end


function calculate_frequency_set(inputs::AbstractVector)
    # Concatenating frequency sets of inputs. Not taking union
    # because, e.g., two FFs with same clock can generate slightly
    # shifted outputs, whose transitions would add up if they control
    # a third signal.

    if isempty(inputs)
        println("Warning: No input to calculate frequency set! Returning zero.")
        return 0
    end
                
    freq = 0
    for x in inputs
        if !isnothing(x)
            freq += x
        else
            println("Warning: Missing frequency set at input! Assuming as zero.")
        end
    end
    return freq
end


"Tag cycles and cycle driven circuit."
function mark_cycle_driven!(design::Design)
    g = design.graph

    function mark_as_cycle_driven(v::Vertex)
        for e in outgoing_edges(v)
            e["cycle_driven"] = true
        end
    end

    feedback_arcs = feedback_arc_set(g)
    if length(feedback_arcs) > 0
        # Cycles found
        depth_first_search(g, map(target, feedback_arcs); cb_at_discovery=mark_as_cycle_driven)
    end
end


"Initialize key attribute of previously uninitialized outgoing edges of ports."
function init_outgoing_edge_attribute(ports::AbstractVector{Vertex}, key, val)
    for p in ports
        for e in outgoing_edges(p)
            if !haskey(e, key)
                e[key] = deepcopy(val)
            end
        end
    end
end

function get_outgoing_edge_attribute(port::Vertex, key)
    values = map(outgoing_edges(port)) do e
        if haskey(e, key)
            e[key]
        else
            nothing
        end
    end
    if length(values) > 0
        @assert all(values[1] .== values)
    end
    values
end

function init_edge_attribute(ports::AbstractVector{Vertex}, key, val)
    for p in ports
        for e in edges(p)
            if !haskey(e, key)
                e[key] = deepcopy(val)
            end
        end
    end
end


"Generic propagation on a design."
function propagate!(f::Function, design::Design, attribute_key; init_primary_inputs=nothing, init_constant_signals=nothing, cb_at_no_input::Function=v->nothing)
    g = design.graph
    primary_ports = design.primary_ports

    # Initialize primary inputs
    if !isnothing(init_primary_inputs)
        init_outgoing_edge_attribute(filter(is_primary_input, primary_ports), 
                                     attribute_key, init_primary_inputs)
    end
    
    # Initialize constant signals
    if !isnothing(init_constant_signals)
        init_outgoing_edge_attribute(filter(p->p["signal_type"] == "constant", vertices(g)),
                                     attribute_key, init_constant_signals)
    end

    # Propagate
    for v in topological_sort(g)
        out_edges = filter(e -> !is_cycle_driven(e) && !haskey(e, attribute_key), outgoing_edges(v))
        if length(out_edges) == 0
            continue
        end

        inputs = map(incoming_edges(v)) do e
            if haskey(e, attribute_key)
                e[attribute_key]
            else
                nothing
            end
        end

        if isempty(inputs)
            cb_at_no_input(v)
        end
        
        y = f(inputs)

        if !isnothing(y)
            for e in out_edges
                e[attribute_key] = y
            end
        end
        #println("Propagating $y across port $(v.id).")
    end
end


"Assign activity factors to design."
function assign_activity_factors!(netlist::DesignNetlist, lib::CellLibrary)
    g = netlist.graph
    primary_ports = netlist.primary_ports
    cells = netlist.cells

    # Assign 1/2 to flip-flop outputs.
    # According to the presence of an IO path from a clock/asynchronous input.
    for c in cells
        cell_type = c["type"]
        for in_p in input_ports(c)
            signal_type = get_port_signal_type(lib, cell_type, in_p["name"])
            if signal_type == "clock" || signal_type == "asynchronous"
                # Assuming all clock and asynchronous inputs have effect only at one edge.
                for out_p in targets(in_p)
                    signal_type = get_port_signal_type(lib, cell_type, out_p["name"])
                    if signal_type == "data"
                        for e in outgoing_edges(out_p)
                            if !haskey(e, "activity_factor")
                                e["activity_factor"] = 0.5
                            end
                        end
                    end
                end
            end
        end
    end

    mark_cycle_driven!(netlist)

    function no_input_func(v::Vertex)
        println("The following port has no input to calculate activity factor:")
        println_short(v)
    end
    
    propagate!(calculate_activity_factor, netlist, "activity_factor", init_primary_inputs=1, init_constant_signals=0, cb_at_no_input=no_input_func)
end


function generate_disguised_graph!(netlist::DesignNetlist; remove_info=true)
    #netlist2 = deepcopy(netlist) # deepcopy produces StackOverflowError
    # Modified the function to "in place".
    # Netlist can be copied elsewhere if need be.
    netlist2 = netlist
    
    g = netlist2.graph
    primary_ports = netlist2.primary_ports
    attributes = netlist2.attributes
    
    if remove_info
        for v in vertices(g)
            if !is_primary(v)
                delete!(v, "name")
                delete!(v, "cell_type")
                delete!(v, "direction")
            end
        end
        
        for e in edges(g)
        end
    end

    return DisguisedDesign(g, primary_ports, attributes)
end


# Assuming that primary I/O delays were specified beforehand.

# Tao = R * C
# where Tao is the time required to charge 63.2% of the voltage.
# The assigned capacitance values are per Tao/R.
function infer_load_capacitance_from_delay!(design::Design)
    g = design.graph

    edges_without_delay = []
    primary_ports_without_delay = []
    
    for e in edges(g)
        if haskey(e, "sdf_delay_list")
            delay = maximum(map(d->d.delay.max, e["sdf_delay_list"]))
        else
            if source(e)["signal_type"] == "constant"
                delay = 0
            elseif ((p = source(e)) |> is_primary) || ((p = target(e)) |> is_primary)
                push!(primary_ports_without_delay, p)
                delay = 0
            else
                push!(edges_without_delay, e)
                delay = 0
            end
        end
        
        e["load_capacitance_from_delay"] = delay
    end

    if !isempty(primary_ports_without_delay)
        println("Warning: Delay of edges connected to $(length(primary_ports_without_delay)) primary ports are not specified. Assuming zero.")
    end
    if !isempty(edges_without_delay)
        println("Warning: Delay of $(length(edges_without_delay)) edges are not specified. Assuming zero.")
    end
end


function assign_capacitance_per_wire!(design::Design)
    g = design.graph

    for e in edges(g)
        e["load_capacitance_per_wire"] = 1
    end
end


function get_relative_arrival_time(clk_port, data_port, arrival_time_key)
    if !haskey(clk_port,  arrival_time_key)
        println("Warning: $arrival_time_key was not set for clock port $(clk_port.id)!")
        # This means that clk_sources defined above doesn't
        # reach this port. It should be addressed.
        return nothing
    end
    if !haskey(data_port,  arrival_time_key)
        # This may be due to a primary input directly leading
        # to a flip-flop. Which is ok.
        return nothing
    end
    clk_arrival = clk_port[arrival_time_key]
    data_arrival = data_port[arrival_time_key]
    
    rel_arrival = data_arrival - clk_arrival
    return rel_arrival
end


function add_remaining_io_paths!(netlist::DesignNetlist, lib::CellLibrary)
    g = netlist.graph
    
    for cell in netlist.cells
        # Check if cell has any IO path infered from SDF. A cell is
        # expected to have at least one IO path.
        cell_inputs = input_ports(cell)
        if !isempty(cell_inputs)
            cell_paths = vcat(map(outgoing_edges, cell_inputs)...)
            if isempty(cell_paths)
                cell_name = cell["name"]
                cell_type = cell["type"]
                println("Warning: Cell of type $(cell_type) name $(cell_name) doesn't have any IO paths in SDF file!")
            end
        end

        # Add IO paths specified in cell library.
        paths = get_io_paths(lib, cell["type"])
        if !isnothing(paths)
            for (src_port_name, src_bus_index, dst_port_name, dst_bus_index) in paths
                src_ports = find_ports(ports(cell), src_port_name, src_bus_index)
                dst_ports = find_ports(ports(cell), dst_port_name, dst_bus_index)
                for (src_port, dst_port) in make_port_pairs(src_ports, dst_ports)
                    if isnothing(edge_between(src_port, dst_port))
                        println("No IO path between the following ports, adding one.")
                        println_short(src_port)
                        println_short(dst_port)
                        e = Edge(src_port, dst_port)
                        add_edge!(g, e)
                    end
                end
            end
        end
    end
end


"Remove IO paths where the input does not effect the output."
function remove_unnecessary_io_paths!(netlist::DesignNetlist, lib::CellLibrary)
    cells = netlist.cells

    for c in cells
        io_paths = get_ineffective_io_paths(lib, c["type"], c["parameters"])
        for (src_port, dst_port) in io_paths
            src_port = find_single(p -> p["name"] == src_port, ports(c))
            dst_port = find_single(p -> p["name"] == dst_port, ports(c))
            remove_edge!(src_port, dst_port)
        end 
    end
end


#
# Circuit Disguise interface
#

"""
    read_netlist(;netlist_fname_json::AbstractString,
                  delays_fname_sdf::AbstractString,
                  cell_library::AbstractString)

Read netlist. Return a `Tuple` `(netlist, lib)` of a `DesignNetlist`
and a `CellLibrary` object.

# Arguments

- `netlist_fname_json`: path to the netlist file in JSON
- `delays_fname_sdf`: path to `delays.sdf`
- `cell_library`: cell library name, e.g., `"xilinx_7"`

"""
function read_netlist(;netlist_fname_json::AbstractString,
                      delays_fname_sdf::AbstractString,
                      cell_library::AbstractString)

    lib = make_cell_library(cell_library)
    netlist = read_netlist_json(netlist_fname_json, lib)

    top_level_module_delays, cell_delays = read_delays_sdf(delays_fname_sdf)
    add_delays_to_design!(netlist, top_level_module_delays, cell_delays)

    add_remaining_io_paths!(netlist, lib)

    remove_unnecessary_io_paths!(netlist, lib)

    return (netlist, lib)
end


"""
    disguise_design!(netlist::DesignNetlist, lib::CellLibrary; remove_info=true)

Disguise `netlist` and return a `DisguisedDesign`
object. `disguise_design!` modifies `netlist` with new information
calculated during the disguise before generating the disguised
design. `remove_info` can be set to `false` for debugging purposes to
prevent information removal during disguise.

"""
function disguise_design!(netlist::DesignNetlist, lib::CellLibrary; remove_info=true)
    flag_short_circuits!(netlist)
    flag_ports!(netlist, lib)
    assign_activity_factors!(netlist, lib)
    # TODO: assign_load_capacitances!(...)
    return generate_disguised_graph!(netlist; remove_info)
end


"""
    save_design(fname::AbstractString, design::Design)

Save `design` into file.
"""
save_design(fname::AbstractString, design::Design) = ser.serialize(fname, design)


"""
    load_design(fname::AbstractString)

Load design that was saved into a file via `save_design`.
"""
function load_design(fname::AbstractString)
    design = ser.deserialize(fname)
    if !isa(design, Design)
        error("Loaded design is not of type 'Design', but '$(typeof(design))'!")
    end
    return design
end


"""
    check_cycles(design::Design)

Check `design` for combinational cycles. Return a `Report`
object. Report status is set to `PASS` if there are no combinational
cycles in `design`.

"""
function check_cycles(design::Design)
    g = design.graph

    feedback_arcs = feedback_arc_set(g)
    passed = length(feedback_arcs) == 0

    Report("Cycle Report", passed, (;feedback_arcs))
end


"""
    check_fanout(design::Design; max_fanout_threshold=Inf, average_fanout_threshold=Inf)

Check `design` for excessive fan-out. Return a `Report` object. Report
status is set to `PASS` if maximum fan-out and average fan-out are
less than or equal to their respective thresholds,
`max_fanout_threshold` and `average_fanout_threshold`.

"""
function check_fanout(design::Design; max_fanout_threshold=Inf, average_fanout_threshold=Inf)
    g = design.graph

    fanouts = map(v->length(outgoing_edges(v)), vertices(g))
    hist = make_histogram(fanouts)

    max_fanout = maximum(keys(hist))
    average_fanout = 0
    N = 0
    for (k, v) in pairs(hist)
        average_fanout += k * v
        N += v
    end
    average_fanout /= N

    passed = max_fanout <= max_fanout_threshold && average_fanout <= average_fanout_threshold
    
    return Report("Fanout Report", passed, (;fanout_histogram=hist, max_fanout, average_fanout, max_fanout_threshold, average_fanout_threshold))
end


"""
    check_signal_connections(design::Design)

Check `design` for data-to-clock and data-to-asynchronous signal
connections. Return a `Report` object. Report status is set to `PASS`
if there are no data-to-clock or data-to-asynchronous signal
connections in `design`.

"""
function check_signal_connections(design::Design)
    g = design.graph

    bad_connections = []
    for dst in vertices(g)
        type = dst["signal_type"]
        #if type == "clock" || type == "asynchronous"
        if type == "clock"
            bad_sources = []
            function process_port(v)
                if v["signal_type"] == "data"
                    push!(bad_sources, v)
                end
            end

            # TODO: Optimize signal connection check.
            # It is not necessary to perform DFS for each graph vertex.
            depth_first_search(g, dst; backwards=true, cb_at_discovery=process_port)
            
            if !isempty(bad_sources)
                push!(bad_connections, bad_sources[1] => dst)
            end
        end
    end

    passed = isempty(bad_connections)
    
    return Report("Signal Connection Report", passed, (;bad_connections))
end


"""
    check_short_circuits(design::Design)

Check `design` for short circuits. Return a `Report` object. Report
status is set to `PASS` if there are no short circuits in `design`.

"""
function check_short_circuits(design::Design)
    short_circuited_ports = filter(is_short_circuit, vertices(design.graph))
    passed = isempty(short_circuited_ports)

    return Report("Short-Circuit Report", passed, (;short_circuited_ports))
end


"""
    set_delay!(port::Vertex, delay)

Set `delay` (in seconds) to outgoing edges of `port`, e.g., a primary
port.

"""
function set_delay!(port::Vertex, delay)
    for e in outgoing_edges(port)
        e["sdf_delay_list"] = make_sdf_delay(delay)
    end
end


"""
    set_primary_port_delay!(design::Design, delay)

Set delay `delay` to edges of `design`'s all primary ports that
doesn't have any associated delay.

"""
function set_primary_port_delay!(design::Design, delay)
    init_edge_attribute(design.primary_ports, "sdf_delay_list", make_sdf_delay(delay))
end


"""
    set_frequency!(port::Vertex, freq)

Set frequency (in Hz) to outgoing edges of `port`, e.g., a primary
clock input or an output of an internal clock generator.

"""
function set_frequency!(port::Vertex, freq)
    for e in outgoing_edges(port)
        e["frequency"] = freq
    end
end


"""
    set_primary_input_frequency!(design::Design, dict::AbstractDict)

For each (`port_name` => `frequency`) pair in `dict`, set the
frequency (in Hz) to outgoing edges of the primary port named
`port_name`.

"""
function set_primary_input_frequency!(design::Design, dict::AbstractDict)
    for (port_name, freq) in pairs(dict)
        port = find_single(p -> p["name"] == port_name, design.primary_ports)
        set_frequency!(port, freq)
    end
end


"""
    propagate_frequency!(design::Design; primary_input_freq=nothing)

Propagate frequencies through `design`. Optionally, set primary input
frequencies to `primary_input_freq` beforehand. `primary_input_freq`
option only affects primary ports with no associated frequency.

"""
function propagate_frequency!(design::Design; primary_input_freq=nothing)
    propagate!(calculate_frequency_set, design, "frequency", init_constant_signals=0, init_primary_inputs=primary_input_freq)
end


"""
    check_power(design::Design;
                load_capacitance_source="from_delay",
                slew_rate=Inf,
                max_dynamic_power_threshold=Inf,
                total_dynamic_power_threshold=Inf)

Check `design` for excessive dynamic power consumption. Return a
`Report` object. Report status is set to `PASS` if dynamic power of
every wire and total dynamic power are less than or equal to their
respective thresholds, `max_dynamic_power_threshold` and
`total_dynamic_power_threshold`.

Power check requires the frequencies of the primary inputs, along with
other signals, such as, output of clock management modules, to be set
and propagated.

Possible options for `load_capacitance_source` is as follows:
`"from_delay"`: Infer load capacitance values from delays.
`"per_wire"`: Assign 1 to each wire.

Infering load capacitances from delays requires the primary I/O delays
to be set.

An optional `slew_rate` (maximum number of transitions per second) can
be specified, in which case, transition density of a wire is assumed
to be bounded. This may be a better representation of real life, as,
in real life, transition density is limited due to non-zero rising and
falling times.

"""
function check_power(design::Design; load_capacitance_source="from_delay", slew_rate=Inf, max_dynamic_power_threshold=Inf, total_dynamic_power_threshold=Inf)
    g = design.graph

    if load_capacitance_source == "from_delay"
        load_capacitance_key = "load_capacitance_from_delay"
        infer_load_capacitance_from_delay!(design)
    elseif load_capacitance_source == "per_wire"
        load_capacitance_key = "load_capacitance_per_wire"
        assign_capacitance_per_wire!(design)
    else
        error("Invalid load capacitance source $(load_capacitance_source)!")
    end

    # D(x) = 2 * K * f
    # Pdyn = 1/2 * C * Vdd^2 * D(x)
    #      = C * Vdd^2 * K * f
    
    # Calculating Pdyn per Vdd^2
    # With "per_wire", calculating Pdyn per Vdd^2 * C where C is the fixed capacitance of each wire
    dynamic_power = []
    for e in edges(g)
        is_valid = map([load_capacitance_key, "activity_factor", "frequency"]) do k
            if haskey(e, k)
                true
            elseif is_cycle_driven(e)
                false
            else
                println("Warning: $k is not defined for edge $(e.id)!")
                false
            end
        end
        if !all(is_valid)
            continue
        end

        C = e[load_capacitance_key]
        K = e["activity_factor"]        
        f = e["frequency"]

        transition_density = 2 * K * f

        if transition_density > slew_rate
            transition_density = slew_rate
        end
        
        Pdyn = 0.5 * C * transition_density
        push!(dynamic_power, Pdyn)
    end

    if isempty(dynamic_power)
        max_dynamic_power = nothing
        total_dynamic_power = 0
    else
        max_dynamic_power = maximum(dynamic_power)
        total_dynamic_power = sum(dynamic_power)
    end

    passed = max_dynamic_power <= max_dynamic_power_threshold && total_dynamic_power <= total_dynamic_power_threshold

    return Report("Power Report", passed, (;max_dynamic_power, max_dynamic_power_threshold, total_dynamic_power, total_dynamic_power_threshold))
end


"""
    check_timing!(design::Design)

Check `design` for setup and hold timing violations. Return a `Report`
object. Report status is set to `PASS` if no timing violations are
detected.

Timing check requires the frequencies of the primary inputs, along with
other signals, such as, output of clock management modules, to be set
and propagated.

Timing check also requires a delay associated to every primary port.

"""
function check_timing!(design::Design)
    g = design.graph
    
    # Cycle driven wires are assumed to be marked beforehand.

    # Find clock sources. Trace every clk port back to their
    # origins. Regardless of presence of data-to-clock connection.
    clk_sources = []
    function process_port(p)
        if isempty(incoming_edges(p))
            push!(clk_sources, p)
        end
    end    
    clk_ports = filter(p->p["signal_type"] == "clock", vertices(g))
    depth_first_search(g, clk_ports; backwards=true, cb_at_discovery=process_port)

    # Get clock frequencies that were specified by the user, to
    # include in the report.
    clk_freqs = map(p -> get_outgoing_edge_attribute(p, "frequency"), clk_sources)

    # Propagate arrival time from clock sources.
    visited_clk_ports = Dict()
    
    for (i, clk_src) in enumerate(clk_sources)
        key = "arrival_time_$i"
        clk_src[key] = Triple(0)

        visited_clk_ports[key] = []
        n_edges_without_delay = 0
        
        for v in topological_sort(g)
            haskey(v, key) && continue

            in_edges = filter(e->!is_cycle_driven(e) && haskey(source(e), key), incoming_edges(v))
            if !isempty(in_edges)
                delays = Triple[]
                for e in in_edges
                    src_arrival_time = source(e)[key]
                    if haskey(e, "sdf_delay_list")
                        append!(delays, map(d->d.delay + src_arrival_time, e["sdf_delay_list"]))
                    else
                        n_edges_without_delay += 1
                        append!(delays, 0)
                    end
                end
                delay = unite(delays)
                v[key] = delay
                if v["signal_type"] == "clock"
                    push!(visited_clk_ports[key], v)
                end
            end
        end

        if n_edges_without_delay > 0
            println("Warning: $n_edges_without_delay edges doesn't have sdf_delay_list. Assuming zero. ($key)")
        end
    end

    n_visited_clk_ports = sum(map(length, values(visited_clk_ports)), init=0)
    if length(clk_ports) != n_visited_clk_ports
        println("Warning: Arrival time is assigned to $n_visited_clk_ports out of $(length(clk_ports)) clock ports!")
    end
    
    # For each pair of clk-data ports in sdf timing info, compare arrival times.
    clk_data_duos = Set()
    for hold in design["sdf_hold_limits"]
        push!(clk_data_duos, (hold.clk_port, hold.data_port))
    end
    for setup in design["sdf_setup_limits"]
        push!(clk_data_duos, (setup.clk_port, setup.data_port))
    end

    static_timing_analysis = []
    hold_violations = []
    setup_violations = []
    clk_ports_without_arrival_time = Set()

    typical_arrival_min = Inf
    typical_arrival_max = -Inf
    all_hold_slacks = []
    all_setup_slacks = []
    
    for (clk_port, data_port) in clk_data_duos
        arrival_time_keys = []
        for i in 1:length(clk_sources)
            if haskey(clk_port, "arrival_time_$i")
                push!(arrival_time_keys, "arrival_time_$i")
            end
        end
        if length(arrival_time_keys) == 0
            push!(clk_ports_without_arrival_time, clk_port)
            continue
        elseif length(arrival_time_keys) > 1
            println("Warning: More than one arrival time is specified for clock port $(clk_port.id)!")
        end

        for (i, key) in enumerate(arrival_time_keys)
            clk_src = clk_sources[i]
            
            rel_arrival = get_relative_arrival_time(clk_port, data_port, key)
            isnothing(rel_arrival) && continue

            rel_arrival.typical < typical_arrival_min && (typical_arrival_min = rel_arrival.typical)
            rel_arrival.typical > typical_arrival_max && (typical_arrival_max = rel_arrival.typical)

            holds = filter(h->h.clk_port == clk_port && h.data_port == data_port, design["sdf_hold_limits"])
            setups = filter(h->h.clk_port == clk_port && h.data_port == data_port, design["sdf_setup_limits"])
            if isempty(holds)
                println("Warning: No hold limit is specified for ports $(clk_port.id) and $(data_port.id) while a setup limit is specified.")
            end
            if isempty(setups)
                println("Warning: No setup limit is specified for ports $(clk_port.id) and $(data_port.id) while a hold limit is specified.")
            end

            hold_slacks = map(hold -> rel_arrival - hold.hold, holds)
            append!(all_hold_slacks, hold_slacks)
            
            hold_status = all(map(s -> s.typical < 0, hold_slacks))
            hold_status && push!(hold_violations, (;clk_port, data_port, hold_slacks))
                
            # Get period from frequency attribute of clock port.
            period = Inf
            clk_edges = incoming_edges(clk_port)
            @assert length(clk_edges) <= 1
            if length(clk_edges) == 1
                freq = clk_edges[1]["frequency"]
                if freq > 0
                    period = 1 / freq
                end
            end

            setup_slacks = map(setup -> period - rel_arrival - setup.setup, setups)
            append!(all_setup_slacks, setup_slacks)
            
            setup_status = all(map(s -> s.typical < 0, setup_slacks))
            setup_status && push!(setup_violations, (;clk_port, data_port, setup_slacks))

            push!(static_timing_analysis, (;clk_source=clk_src, clk_port, data_port, relative_arrival_time=rel_arrival))
        end
    end

    if !isempty(clk_ports_without_arrival_time)
        println("Warning: No arrival time specified for $(length(clk_ports_without_arrival_time)) clock port(s)!")
    end

    passed = isempty(hold_violations) && isempty(setup_violations)

    if length(all_hold_slacks) > 0
        min_hold_slack = minimum(map(d->d.typical, all_hold_slacks))
    else
        min_hold_slack = nothing
    end

    if length(all_setup_slacks) > 0
        min_setup_slack = minimum(map(d->d.typical, all_setup_slacks))
    else
        min_setup_slack = nothing
    end

    return Report("Timing Report", passed, (;clock_sources=clk_sources, clk_frequencies=clk_freqs, static_timing_analysis, hold_violations, setup_violations, typical_arrival_min, typical_arrival_max, min_hold_slack, min_setup_slack))
end


# In check_power, infering load capacitance from delay require the
# primary I/O delays to be set.

"""
    check_design!(disguised_design::DisguisedDesign;
                  primary_port_delay=nothing,
                  primary_input_freq=nothing, kwargs...)

Perform the following checks on `disguised_design`: `check_cycles`,
`check_fanout`, `check_signal_connections`, `check_short_circuits`,
`check_power`, `check_timing!`.

Optionally, set uninitialized primary port delays to
`primary_port_delay`.

Optionally, set uninitialized primary input frequencies to
`primary_input_freq` and propagate the frequencies throuth
`disguised_design`.

Keyword arguments supported by the enlisted checks can be also
provided to `check_design!`.

Return a `NamedTuple` of the resulting reports.

"""
function check_design!(disguised_design::DisguisedDesign; primary_port_delay=nothing, primary_input_freq=nothing, max_fanout_threshold=Inf, average_fanout_threshold=Inf, load_capacitance_source="from_delay", slew_rate=Inf, max_dynamic_power_threshold=Inf, total_dynamic_power_threshold=Inf)

    # Delays and frequencies are both used in power and timing check.
    if !isnothing(primary_port_delay)
        set_primary_port_delay!(disguised_design, primary_port_delay)
    end

    # Propagate frequencies
    # Assuming cycles were marked during propagation of activity factors.
    propagate_frequency!(disguised_design; primary_input_freq)
    
    reports =
        (;cycle_report = check_cycles(disguised_design),
         fanout_report = check_fanout(disguised_design; max_fanout_threshold, average_fanout_threshold),
         signal_connection_report = check_signal_connections(disguised_design),
         short_circuit_report = check_short_circuits(disguised_design),
         power_report = check_power(disguised_design; max_dynamic_power_threshold, total_dynamic_power_threshold, load_capacitance_source, slew_rate),
         timing_report = check_timing!(disguised_design))
    
    return reports
end    


end # module CircuitDisguise
