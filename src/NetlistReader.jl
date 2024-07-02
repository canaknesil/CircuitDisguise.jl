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


module NetlistReader

using ..CircuitRepresentation
using ..CellLibraries
using ..SDFParser
using ..Util
import JSON

export read_netlist_json, read_delays_sdf, add_delays_to_design!
export make_sdf_delay
export find_ports, make_port_pairs


#
# Read JSON netlist file
#

# Attributes starting with 'yosys_' is related to how the netlist was
# represented in Yosys, they are removed when their purpose ends.

# bus_index attribute is Julia array index of each port connection bit
# in the order they were in the netlist file. Bus range and direction
# (MSB or LSB first) don't exist in neither netlist file nor SDF
# file. In UG953 library guide, range of all cell ports that is a bus
# is in form N-1 downto 0.

# From Yosys manual: In Verilog and VHDL, busses may have arbitrary
# bounds, and LSB can have either the lowest or the highest bit
# index. In RTLIL, bit 0 always corresponds to LSB; however,
# information from the HDL frontend is preserved so that the bus will
# be correctly indexed in error messages, backend output, constraint
# files, etc.

"Read flattened netlist written in JSON format by Yosys."
function read_netlist_json(fname::AbstractString, lib::CellLibrary)
    j = JSON.parsefile(fname)
    g = Graph()
    
    modules = j["modules"]
    # Only supporting flattened design. Design is expected to be flattened beforehand.
    @assert length(modules) == 1
    top_module = first(values(modules))

    # Read primary ports.
    primary_ports = top_module["ports"]
    primary_ports = map(collect(keys(primary_ports))) do port_name
        port = primary_ports[port_name]
        yosys_bits = port["bits"]
        bus = (length(yosys_bits) > 1)
        vertices = map(enumerate(yosys_bits)) do (idx, bit)
            v = Vertex()
            v["name"] = port_name
            v["cell_type"] = "TOP"
            v["direction"] = port["direction"]
            v["yosys_bit"] = bit
            v["flag_primary"] = true
            if bus
                v["bus_index"] = idx
                v["bus_width"] = length(yosys_bits)
            end
            add_vertex!(g, v)
            v
        end
        vertices
    end
    primary_ports = vcat(primary_ports...)

    # Read cells and cell ports.
    cells = top_module["cells"]
    cells = map(collect(keys(cells))) do cell_name
        cell = cells[cell_name]

        c = Cell()
        c["name"] = convert_name_from_netlist(cell_name)
        c["type"] = cell["type"]
        c["parameters"] = cell["parameters"]

        connections = cell["connections"]
        for (port_name, yosys_bits) in connections
            bus = (length(yosys_bits) > 1)
            for (idx, bit) in enumerate(yosys_bits)
                v = Vertex()
                v["name"] = port_name
                v["cell_type"] = cell["type"]
                v["yosys_bit"] = bit
                v["direction"] = get_port_direction(lib, cell["type"], port_name)
                if bus
                    v["bus_index"] = idx
                    v["bus_width"] = length(yosys_bits)
                end
                add_vertex!(g, v)
                add_port!(c, v)
            end
        end
        
        c
    end

    # Infer edges from connections.
    wires = Dict()
    for v in vertices(g)
        b = v["yosys_bit"]
        if haskey(wires, b)
            push!(wires[b], v)
        else
            wires[b] = [v]
        end
        delete!(v, "yosys_bit")
    end

    for ports in values(wires)
        sources = filter(is_driver, ports)
        destinations = filter(!is_driver, ports)
        if isempty(sources)
            # Wire doesn't have any drivers.
        end
        if isempty(destinations)
            # Wire doesn't drive anything.
        end
        if length(sources) > 1
            # Short circuit
            print("Short circuit detected with the following drivers: ")
            print_ids(sources)
            println()
        end
        if ! isempty(sources) && ! isempty(destinations)
            for src in sources
                for dst in destinations
                    e = Edge(src, dst)
                    add_edge!(g, e)
                end
            end
        end
    end

    return DesignNetlist(g, primary_ports, cells)
end



#
# Read SDF delays file
#

struct Delay
    delay::Triple
    r_limit::Triple  # pulse rejection limit (r-limit)
    e_limit::Triple  # X filter limit (e-limit).
end

Delay(n) = Delay(n, n, n)


Base.show(io::IO, d::Delay) =
    print(io, "Delay(delay=$(d.delay), r_limit=$(d.r_limit), e_limit=$(d.e_limit))")

Base.show(io::IO, da::AbstractVector{Delay}) =
    print(io, "Delay[...]")


"Make SDF delay (delay, r_limit, e_limit)."
make_sdf_delay(delay::Number) = [Delay(delay)]


function node_type(node)
    if isa(node, AbstractDict)
        return node["type"]
    end
    if isa(node, AbstractVector)
        return "exp_list"
    end
    error("Not an AST node!")
end

function step_in(node::AbstractDict, type::AbstractString)
    @assert node_type(node) == type
    return node["value"]
end

function find_node(nodes::AbstractVector, type::AbstractString)
    nodes = filter(n -> node_type(n) == type, nodes)
    nodes = map(n -> step_in(n, type), nodes)
    return nodes
end

function step_in_first(nodes::AbstractVector, type::AbstractString)
    return find_node(nodes, type)[1]
end


"""Name of a given cell instance may be in different formats in the
netlist file and the SDF file. Different divider, excaped brackets in
SDF, etc. This function converts an instance name specified in the SDF
file to the format used in the netlist."""
function convert_name_from_sdf(name::AbstractString, divider::AbstractString)
    # name = replace(name, divider => ".", "\\" => "")
    name = replace(name,
                   ("\\" * divider) => divider,
                   divider => ".")
    name = replace(name, "\\" => "")
    return name
end


function convert_name_from_netlist(name::AbstractString)
    name = replace(name, "\\" => "")
    return name
end


"""
Interconnect source and destinations are specified as cell name
followed by port name. Return cell name and port name.
"""
function parse_interconnect_port(str::AbstractString, divider::AbstractString)
    div = findlast(divider, str)
    @assert !isnothing(div)
    cell_name = str[1:(div.start-1)]
    port_name = str[div.stop+1:end]
    cell_name = convert_name_from_sdf(cell_name, divider)
    return cell_name, port_name
end


"""
Examples:

    "data"      => ("data", []) 
    "data[3]"   => ("data", ["3"])
    "data[3:0]" => ("data", ["3", "2", "1", "0"])
"""
function expand_port_name_inner(port_name)
    # e.g. match port[3]
    r1 = r"(?<port>\S+)\s*\[\s*(?<idx>[0-9]+)\s*\]\s*$"

    # e.g. match port[3:0]
    r2 = r"(?<port>\S+)\s*\[\s*(?<idx1>[0-9]+)\s*:\s*(?<idx2>[0-9]+)\s*\]\s*$"

    m = match(r1, port_name)
    if !isnothing(m)
        # Single wire of bus
        return (m[:port], [m[:idx]])
    end
    
    m = match(r2, port_name)
    if !isnothing(m)
        # multiple wires of bus
        indices = []
        first = parse(Int, m[:idx1])
        last = parse(Int, m[:idx2])
        range = (first <= last ? (first:last) : (first:-1:last))
        for i in range
            push!(indices, string(i))
        end
        return (m[:port], indices)
    end

    # Single wire
    return (port_name, [])
end


"Assuming all bus ports have range N-1 downto 0. Mapping indices so that Julia index 1 corresponds to LSB."
map_port_index(i) = i+1


function expand_port_name(port_name)
    name, indices = expand_port_name_inner(port_name)
    indices = map(indices) do i
        map_port_index(parse(Int, i))
    end
    if isempty(indices)
        indices = [nothing]
    end
    return name, indices
end


"Expand an SDF specification concerning 2 ports, such as an IO path, or a timing constraint."
function expand_port_pair(src_port::AbstractString, dst_port::AbstractString)
    src, src_indices = expand_port_name(src_port)
    dst, dst_indices = expand_port_name(dst_port)
    return make_port_pairs(src, src_indices, dst, dst_indices)    
end


function make_port_pairs(src_port::AbstractString, src_indices, dst_port::AbstractString, dst_indices)
    pairs = map(make_port_pairs(src_indices, dst_indices)) do (src_idx, dst_idx)
        (src_port, src_idx, dst_port, dst_idx)
    end
    return pairs
end


"""

    make_port_pairs(src_ports::AbstractVector, dst_ports::AbstractVector)
    make_port_pairs(src_port::AbstractString, src_indices, dst_port::AbstractString, dst_indices)

This function defines relationship between two port sets in an SDF
specification.

For example: (IOPATH OPMODE[6:0] P[47:0] ...)

Current implementation takes cross-product of two sets.

"""
function make_port_pairs(src_ports::AbstractVector, dst_ports::AbstractVector)
    src_len = length(src_ports)
    dst_len = length(dst_ports)
    @assert src_len >= 1
    @assert dst_len >= 1

    # Following assertion is wrong since there can be a situation with
    # both sets larger than 1 and having different number of elements.
    
    # if src_len > 1 && dst_len > 1
    #     print_verbose(src_ports)
    #     print_verbose(dst_ports)
    #     @assert src_len == dst_len
    # end
        
    pairs = []
    for src in src_ports
        for dst in dst_ports
            push!(pairs, (src, dst))
        end
    end
    return pairs
end


function parse_timescale_unit(unit::AbstractString)
    if length(unit) == 1 && unit == "s"
        return 1.0
    end
    
    @assert(length(unit) == 2)
    if unit == "ms"
        return 1e-3
    elseif unit == "us"
        return 1e-6
    elseif unit == "ns"
        return 1e-9
    elseif unit == "ps"
        return 1e-12
    elseif unit == "fs"
        return 1e-15
    else
        error("Invalid timescale unit $(unit)!")
    end
end


function parse_timescale(delayfile)
    str = step_in_first(delayfile, "TIMESCALE")
    if str[end-1] >= 'a' && str[end-1] <= 'z'
        n = parse(Float64, str[1:end-2]) * parse_timescale_unit(str[end-1:end])
    else
        @assert(str[end] == 's')
        n = parse(Float64, str[1:end-1])
    end
   
    return n
end


filter_in_two(f::Function, a) = (filter(f, a), filter(!f, a))


function parse_top_level_cell(cell, divider, timescale)
    type = step_in_first(cell, "CELLTYPE")

    name = step_in_first(cell, "INSTANCE")
    @assert name == ""

    # Extract interconnections
    interconnects = []
    for delay in find_node(cell, "DELAY")
        for absolute in find_node(delay, "ABSOLUTE")
            for ic in find_node(absolute, "INTERCONNECT")
                src = ic["src_port"]
                dst = ic["dst_port"]
                src_cell_name, src = parse_interconnect_port(src, divider)
                dst_cell_name, dst = parse_interconnect_port(dst, divider)

                delval_list = parse_delval_list(ic["delval_list"], timescale)

                for (src, src_index, dst, dst_index) in expand_port_pair(src, dst)
                    info = (;src, src_index, dst, dst_index, delay_list=delval_list, src_cell_name, dst_cell_name)
                    push!(interconnects, info)
                end
            end
        end
    end

    return (;type, name, interconnects)
end


function parse_port_spec(node)
    node = step_in(node, "port_spec")
    port = node["port"]
    port_edge = node["edge"]
    return port, port_edge
end


function parse_port_tchk(node)
    node = step_in(node, "port_tchk")
    if node_type(node) == "port_spec"
        return parse_port_spec(node)
    end
    @assert node_type(node) == "COND"
    error("Parsing conditional port_tchk (COND ...) not implemented!")
end


function parse_value(value::AbstractString)
    if isempty(value)
        min_val = typical_val = max_val = nothing
    elseif length(filter(==(':'), value)) == 2
        min_val, typical_val, max_val = map(n->parse(Float64, n), split(value, ":"))
        if !check_triple(min_val, typical_val, max_val)
            print("Warning: Value '$value' read from SDF file does not follow $min_val <= $typical_val <= $(max_val)!. The error is probably in the order. ")
            min_val, typical_val, max_val = sort([min_val, typical_val, max_val])
            println("Reordering as '$min_val : $typical_val : $max_val'.")
        end
    else
        min_val = typical_val = max_val = parse(Float64, value)
    end

    return Triple(min_val, typical_val, max_val)
end


function parse_delval_list(delval_list, timescale)
    @assert length(delval_list) in [1, 2, 3, 6, 12]

    delval_list = map(delval_list) do delval
        if isa(delval, AbstractString)
            delay = r_limit = e_limit = parse_value(delval)
        elseif isa(delval, AbstractVector{<:AbstractString})
            @assert length(delval) in [2, 3]
            delay = parse_value(delval[1])
            r_limit = parse_value(delval[2])
            if length(delval) == 2
                e_limit = r_limit
            else
                e_limit = parse_value(delval[3])
            end
        else
            error("Invalid delval!")
        end

        Delay(delay * timescale, r_limit * timescale, e_limit * timescale)
    end
    
    return delval_list
end


function parse_regular_cell(cell, divider, timescale)
    type = step_in_first(cell, "CELLTYPE")

    name = step_in_first(cell, "INSTANCE")
    name = convert_name_from_sdf(name, divider)

    # Extract IO paths
    io_paths = []
    for delay in find_node(cell, "DELAY")
        for absolute in find_node(delay, "ABSOLUTE")
            for path in find_node(absolute, "IOPATH")
                src, src_edge = parse_port_spec(path["src_port"])
                dst = path["dst_port"]
                src = convert_name_from_sdf(src, divider)
                dst = convert_name_from_sdf(dst, divider)
                retain_delval_list = path["retain_def_list"]
                delval_list = parse_delval_list(path["delval_list"], timescale)
                
                for (src, src_index, dst, dst_index) in expand_port_pair(src, dst)
                    info = (;src, src_index, src_edge, dst, dst_index, delay_list=delval_list, retain_delay_list=retain_delval_list)
                    push!(io_paths, info)
                end
            end
        end
    end

    # Extract timing information
    setup = []
    hold = []
    recovery = []
    removal = []
    period = []
    width = []
    for timingcheck in find_node(cell, "TIMINGCHECK")
        #println("$type $name")
        for check in timingcheck
            t = node_type(check)

            if t == "SETUPHOLD"
                check = step_in(check, t)
                data_port, data_port_edge = parse_port_tchk(check["data_port"])
                clk_port, clk_port_edge = parse_port_tchk(check["clk_port"])
                data_port = convert_name_from_sdf(data_port, divider)
                clk_port = convert_name_from_sdf(clk_port, divider)
                if !isempty(check["scond_ccond"])
                    println("Warning: Parsing conditions in SETUPHOLD is not implemented!")
                end
                setup_val = parse_value(check["setup"]) * timescale
                hold_val = parse_value(check["hold"]) * timescale

                for (data_port, data_port_index, clk_port, clk_port_index) in expand_port_pair(data_port, clk_port)
                    push!(setup, (;data_port, data_port_index, data_port_edge, clk_port, clk_port_index, clk_port_edge, setup=setup_val))
                    push!(hold, (;data_port, data_port_index, data_port_edge, clk_port, clk_port_index, clk_port_edge, hold=hold_val))
                end

            elseif t == "SETUP"
                check = step_in(check, t)
                data_port, data_port_edge = parse_port_tchk(check["data_port"])
                clk_port, clk_port_edge = parse_port_tchk(check["clk_port"])
                data_port = convert_name_from_sdf(data_port, divider)
                clk_port = convert_name_from_sdf(clk_port, divider)
                setup_val = parse_value(check["val"]) * timescale

                for (data_port, data_port_index, clk_port, clk_port_index) in expand_port_pair(data_port, clk_port)
                    push!(setup, (;data_port, data_port_index, data_port_edge, clk_port, clk_port_index, clk_port_edge, setup=setup_val))
                end

            elseif t == "HOLD"
                check = step_in(check, t)
                data_port, data_port_edge = parse_port_tchk(check["data_port"])
                clk_port, clk_port_edge = parse_port_tchk(check["clk_port"])
                data_port = convert_name_from_sdf(data_port, divider)
                clk_port = convert_name_from_sdf(clk_port, divider)
                hold_val = parse_value(check["val"]) * timescale

                for (data_port, data_port_index, clk_port, clk_port_index) in expand_port_pair(data_port, clk_port)
                    push!(hold, (;data_port, data_port_index, data_port_edge, clk_port, clk_port_index, clk_port_edge, hold=hold_val))
                end

            elseif t == "RECREM"
                check = step_in(check, t)
                async_port, async_port_edge = parse_port_tchk(check["async_port"])
                clk_port, clk_port_edge = parse_port_tchk(check["clk_port"])
                async_port = convert_name_from_sdf(async_port, divider)
                clk_port = convert_name_from_sdf(clk_port, divider)
                if !isempty(check["scond_ccond"])
                    println("Warning: Parsing conditions in RECREM is not implemented!")
                end
                rec_val = parse_value(check["recovery"]) * timescale
                rem_val = parse_value(check["removal"]) * timescale

                for (async_port, async_port_index, clk_port, clk_port_index) in expand_port_pair(async_port, clk_port)
                    push!(recovery, (;async_port, async_port_index, async_port_edge, clk_port, clk_port_index, clk_port_edge, recovery=rec_val))
                    push!(removal, (;async_port, async_port_index, async_port_edge, clk_port, clk_port_index, clk_port_edge, removal=rem_val))
                end

            elseif t == "PERIOD"
                check = step_in(check, t)
                port, port_edge = parse_port_tchk(check["port"])
                port = convert_name_from_sdf(port, divider)
                port, port_indices = expand_port_name(port)
                val = parse_value(check["val"]) * timescale

                for idx in port_indices
                    push!(period, (;port, port_index=idx, port_edge, period=val))
                end

            elseif t == "WIDTH"
                check = step_in(check, t)
                port, port_edge = parse_port_tchk(check["port"])
                port = convert_name_from_sdf(port, divider)
                port, port_indices = expand_port_name(port)
                val = parse_value(check["val"]) * timescale

                for idx in port_indices
                    push!(width, (;port, port_index=idx, port_edge, width=val))
                end
                
            else
                println("Warning: Parsing timing check of type $t not implement!")
            end
        end
    end

    return (;type, name, io_paths, setup_limits=setup, hold_limits=hold, periods=period, width, recovery_limits=recovery, removal_limits=removal)
end


"Read SDF file. Parse and return only the information necessary for Circuit Disguise."
function read_delays_sdf(fname::AbstractString)
    sdf = parse_sdf_file(fname)

    @assert isa(sdf, AbstractVector)
    delayfile = step_in_first(sdf, "DELAYFILE")

    # Extract top-level module name
    top_level_module_name = step_in_first(delayfile, "DESIGN")

    # Extract hierarchical name divider
    divider = step_in_first(delayfile, "DIVIDER")

    # Extract timescale for delay specifications
    timescale = parse_timescale(delayfile)

    # Process cells
    top_level_cell, cells = filter_in_two(find_node(delayfile, "CELL")) do cell
        name = step_in_first(cell, "INSTANCE")
        name == ""
    end

    @assert length(top_level_cell) <= 1
    if length(top_level_cell) == 1
        # Process top-level module cell
        top_level_cell_info = parse_top_level_cell(top_level_cell[1], divider, timescale)
    else
        top_level_cell_info = nothing
    end

    # Process regular cells
    cells_info = map(c -> parse_regular_cell(c, divider, timescale), cells)
    
    return (top_level_cell_info, cells_info)
end


#
# Add information extracted from SDF file to the design.
#


"""

Return port(s) that is indicated with a port name and an optional
subscript.

In an SDF specification, a port name without a subscript may refers to
a single vertex if the port is not a bus, or it may refer to all the
vertices of a bus.

"""
function find_ports(ports::AbstractVector{Vertex}, name::AbstractString, sdf_bus_index)
    if isnothing(sdf_bus_index)
        # SDF port identifier without indexing can mean a non-bus port, or all the bits of a bus.
        ports = filter(p -> p["name"] == name, ports)
        @assert length(ports) >= 1
        if length(ports) == 1
            @assert !is_bus(ports[1])
        else
            @assert all(is_bus.(ports))
            @assert length(ports) == ports[1]["bus_width"]
        end
    else
        # In Verilog, a single wire can connect to a bus port, which
        # means every index of the bus port should be connected to the
        # single wire. Without the definition of the module being
        # initialized there is no way to tell weather the port is a
        # bus, thus the port is read as a non-bus port by
        # Yosys. Accordingly, SDF file may refer to some indices of
        # the port that was read as non-bus.

        # In a case described above, the following line will give
        # error as bus_index attribute won't exist.
        #port = find_single(p -> p["name"] == name && p["bus_index"] == sdf_bus_index, ports)
        #@assert is_bus(port)
        #ports = [port]

        # TODO: The case described above, will give an incorrect
        # higher fan-out value, in case the port is an output port; an
        # incorrect short-circuit warning, in case the port is an
        # input port. Width of each cell port in the netlist must be
        # known.
        
        ports = filter(ports) do p
            if p["name"] == name
                if is_bus(p)
                    return p["bus_index"] == sdf_bus_index
                else
                    return true
                end
            else
                return false
            end
        end
        @assert length(ports) == 1
    end
    return ports
end


"Add information that was extracted from the SDF file to the design. For every IO path, an edge is created and added to `netlist`."
function add_delays_to_design!(netlist::DesignNetlist, top_level_module_delays, cell_delays)
    g = netlist.graph
    cells = netlist.cells

    # Repeatedly searching cells according to name is slow. Using a
    # dictionary.
    cells_dict = Dict{String, Cell}()
    for c in cells
        @assert !haskey(cells_dict, c)
        cells_dict[c["name"]] = c
    end

    if !isnothing(top_level_module_delays)
        for wire in top_level_module_delays.interconnects
            # Assuming that interconnect delays are specified only
            # in-between cells, and not between a cell and a primary I/O.

            #src_cell = find_single(c -> c["name"] == wire.src_cell_name, cells)
            #dst_cell = find_single(c -> c["name"] == wire.dst_cell_name, cells)
            if !haskey(cells_dict, wire.src_cell_name)
                error("Cell with name '$(wire.src_cell_name)' mentioned in SDF file does not exist in the netlist!")
            end
            if !haskey(cells_dict, wire.dst_cell_name)
                error("Cell with name '$(wire.dst_cell_name)' mentioned in SDF file does not exist in the netlist!")
            end
            src_cell = cells_dict[wire.src_cell_name]
            dst_cell = cells_dict[wire.dst_cell_name]

            #print_verbose(src_cell)
            #print_verbose(dst_cell)

            src_ports = find_ports(ports(src_cell), wire.src, wire.src_index)
            dst_ports = find_ports(ports(dst_cell), wire.dst, wire.dst_index)

            port_pairs = make_port_pairs(src_ports, dst_ports)
            
            for (src_port, dst_port) in port_pairs
                @assert is_driver(src_port)
                @assert !is_driver(dst_port)
                e = find_single(e -> target(e) == dst_port, outgoing_edges(src_port))
                e["sdf_delay_list"] = wire.delay_list
            end
        end
    end

    netlist["sdf_setup_limits"] = []
    netlist["sdf_hold_limits"] = []
    netlist["sdf_recovery_limits"] = []
    netlist["sdf_removal_limits"] = []
    netlist["sdf_periods"] = []
    netlist["sdf_widths"] = []

    # Iterating through all cells for each cell_info is very
    # slow. Instead, creating a cell dictionary w.r.t. name and
    # searching the dictionary.
    name_to_cell_dict = Dict()
    for cell in cells
        name = cell["name"]
        if haskey(name_to_cell_dict, name)
            error("Multiple cells with name '$(name)'!")
        end
        name_to_cell_dict[name] = cell
    end
    
    for cell_info in cell_delays
        if !haskey(name_to_cell_dict, cell_info.name)
            error("Cell from SDF info with type '$(cell_info.type)' name '$(cell_info.name)' doesn't exist in netlist!")
        end
        cell = name_to_cell_dict[cell_info.name]

        cell_ports = ports(cell)

        for iopath in cell_info.io_paths
            # println("Cell type: $(cell_info.type)")
            # println("Cell name: $(cell_info.name)")
            # print_verbose(cell_ports)
            # println("IO path: $iopath")
            src_ports = find_ports(cell_ports, iopath.src, iopath.src_index)
            dst_ports = find_ports(cell_ports, iopath.dst, iopath.dst_index)
            for (src_port, dst_port) in make_port_pairs(src_ports, dst_ports)
                @assert is_driver(dst_port)
                @assert !is_driver(src_port)
                
                e = Edge(src_port, dst_port)
                e["sdf_delay_list"] = iopath.delay_list
                if !isnothing(iopath.src_edge)
                    e["sdf_delay_src_edge"] = iopath.src_edge
                end
                if !isempty(iopath.retain_delay_list)
                    e["sdf_retain_delay_list"] = iopath.retain_delay_list
                end
                add_edge!(g, e)
            end
        end

        for setup in cell_info.setup_limits
            data_ports = find_ports(cell_ports, setup.data_port, setup.data_port_index)
            clk_ports = find_ports(cell_ports, setup.clk_port, setup.clk_port_index)
            for (data_port, clk_port) in make_port_pairs(data_ports, clk_ports)
                @assert !is_driver(data_port)
                @assert !is_driver(clk_port)
                push!(netlist["sdf_setup_limits"], (;clk_port, clk_port_edge=setup.clk_port_edge, data_port, data_port_edge=setup.data_port_edge, setup=setup.setup))
            end
        end

        for hold in cell_info.hold_limits
            # A bus clock signal can technically exist (?). No harm supporting it.
            data_ports = find_ports(cell_ports, hold.data_port, hold.data_port_index)
            clk_ports = find_ports(cell_ports, hold.clk_port, hold.clk_port_index)
            for (data_port, clk_port) in make_port_pairs(data_ports, clk_ports)
                @assert !is_driver(data_port)
                @assert !is_driver(clk_port)
                push!(netlist["sdf_hold_limits"], (;clk_port, clk_port_edge=hold.clk_port_edge, data_port, data_port_edge=hold.data_port_edge, hold=hold.hold))
            end
        end
        
        for rec in cell_info.recovery_limits
            # A bus clock/asynchronous signal can technically exist (?). No harm supporting it.
            async_ports = find_ports(cell_ports, rec.async_port, rec.async_port_index)
            clk_ports = find_ports(cell_ports, rec.clk_port, rec.clk_port_index)
            for (async_port, clk_port) in make_port_pairs(async_ports, clk_ports)
                @assert !is_driver(async_port)
                @assert !is_driver(clk_port)
                push!(netlist["sdf_recovery_limits"], (;clk_port, clk_port_edge=rec.clk_port_edge, async_port, async_port_edge=rec.async_port_edge, recovery=rec.recovery))
            end
        end

        for rem in cell_info.removal_limits
            # A bus clock/asynchronous signal can technically exist (?). No harm supporting it.
            async_ports = find_ports(cell_ports, rem.async_port, rem.async_port_index)
            clk_ports = find_ports(cell_ports, rem.clk_port, rem.clk_port_index)
            for (async_port, clk_port) in make_port_pairs(async_ports, clk_ports)
                @assert !is_driver(async_port)
                @assert !is_driver(clk_port)
                push!(netlist["sdf_removal_limits"], (;clk_port, clk_port_edge=rem.clk_port_edge, async_port, async_port_edge=rem.async_port_edge, removal=rem.removal))
            end
        end
        
        for period in cell_info.periods
            ports = find_ports(cell_ports, period.port, period.port_index)
            for port in ports
                push!(netlist["sdf_periods"], (;port, port_edge=period.port_edge, period=period.period))
            end
        end

        for width in cell_info.width
            ports = find_ports(cell_ports, width.port, width.port_index)
            for port in ports
                push!(netlist["sdf_widths"], (;port, port_edge=width.port_edge, width=width.width))
            end
        end
    end
end


end # module NetlistReader
