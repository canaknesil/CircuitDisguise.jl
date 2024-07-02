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


module CircuitDisguiseTest

using CircuitDisguise
using Test

export simple_designs_dir
export PASS, FAIL, X, Unit, generic_unit
export test_design, test_unit
export test_example, test_examples


#
# Design directories
#

simple_designs_dir = joinpath(@__DIR__, "../simple-designs")


#
# ReportStatus (PASS, FAIL, X)
#

const PASS = true
const FAIL = false

struct DontCare <: Integer end
const X = DontCare()
const ReportStatus = Union{Bool, DontCare}

Base.:(==)(x::DontCare, y::DontCare) = X
Base.promote_rule(::Type{DontCare}, ::Type{<:Number}) = DontCare
DontCare(b::Bool) = X

passed(st::Bool) = st
passed(st::DontCare) = true


#
# Test unit
#

struct Unit
    design_dir::AbstractString
    cell_library::AbstractString
    cycle_report::ReportStatus # Expected report status
    max_fanout_threshold
    average_fanout_threshold
    fanout_report::ReportStatus
    signal_connection_report::ReportStatus
    short_circuit_report::ReportStatus
    load_capacitance_source
    slew_rate
    max_dynamic_power_threshold
    total_dynamic_power_threshold
    power_report::ReportStatus
    timing_report::ReportStatus
    primary_input_frequencies::AbstractDict
end

Unit(design_dir, cell_library; cycle_report=PASS, max_fanout_threshold=Inf, average_fanout_threshold=Inf, fanout_report=PASS, signal_connection_report=PASS, short_circuit_report=PASS, load_capacitance_source="from_delay", slew_rate=8e9, max_dynamic_power_threshold=Inf, total_dynamic_power_threshold=Inf, power_report=PASS, timing_report=PASS, primary_input_frequencies=Dict()) =
    Unit(design_dir, cell_library, cycle_report, max_fanout_threshold, average_fanout_threshold, fanout_report, signal_connection_report, short_circuit_report, load_capacitance_source, slew_rate, max_dynamic_power_threshold, total_dynamic_power_threshold, power_report, timing_report, primary_input_frequencies)

generic_unit(design_dir, cell_library) = Unit(design_dir, cell_library, X, Inf, Inf, X, X, X, "from_delay", Inf, Inf, Inf, X, X, Dict())


#
# Test functions
#

test_design(design_dir::AbstractString, cell_library::AbstractString; kwargs...) =
    test_design(generic_unit(design_dir, cell_library); kwargs...)
                

function test_design(u::Unit; verbose=false)
    netlist_fname =  joinpath(u.design_dir, "netlist.json")
    delays_fname = joinpath(u.design_dir, "delays.sdf")

    @time begin
        println("Reading netlist...")
        netlist, lib = read_netlist(netlist_fname_json = netlist_fname,
                                    delays_fname_sdf = delays_fname,
                                    cell_library = u.cell_library)

        println("Disguising...")
        disguised_design = disguise_design!(netlist, lib, remove_info=false)

        if verbose
            print_verbose(netlist.cells)
            println()
        end

        # Big designs gives StackOverflowError due to recursion during
        # serialization.
        # println("Saving design...")
        # disguised_path = tempname()
        # save_design(disguised_path, disguised_design)

        # println("Loading design...")
        # disguised_design = load_design(disguised_path)
        # rm(disguised_path)

        println("Checking...")
        set_primary_input_frequency!(disguised_design, u.primary_input_frequencies)
                
        reports = check_design!(disguised_design; primary_port_delay=0, primary_input_freq=100e6, max_fanout_threshold=u.max_fanout_threshold, average_fanout_threshold=u.average_fanout_threshold, load_capacitance_source=u.load_capacitance_source, slew_rate=u.slew_rate, max_dynamic_power_threshold=u.max_dynamic_power_threshold, total_dynamic_power_threshold=u.total_dynamic_power_threshold)

        if verbose    
            print_verbose(disguised_design.graph)
            println()

            for r in reports
                print_verbose(r)
            end
            println()
        end
    end

    return reports
end


test_unit(unit::Unit; kwargs...) = test_unit([unit]; kwargs...)

function test_unit(units::AbstractVector{Unit}; kwargs...)
    @testset "CircuitDisguise" begin
        unit_reports = []
        @testset "Runtime sanity" begin
            N = length(units)
            for (i, unit) in enumerate(units)
                success = try
                    print("($i / $N) ")
                    println("Testing design $(unit.design_dir)")
                    reports = test_design(unit; kwargs...)
                    push!(unit_reports, (unit, reports))
                    true
                catch e
                    showerror(stdout, e)
                    println()
                    false
                end
                @test success
            end
        end
        
        @testset "Cycle check" begin
            println("Cycle check")
            for (unit, reports) in unit_reports
                println("  $(unit.design_dir)")
                @test passed(reports.cycle_report.passed == unit.cycle_report)
            end
        end
        @testset "Fan-out check" begin
            println("Fan-out check")
            for (unit, reports) in unit_reports
                println("  $(unit.design_dir)")
                @test passed(reports.fanout_report.passed == unit.fanout_report)
            end
        end
        @testset "Signal connection check" begin
            println("Signal connection check")
            for (unit, reports) in unit_reports
                println("  $(unit.design_dir)")
                @test passed(reports.signal_connection_report.passed == unit.signal_connection_report)
            end
        end
        @testset "Short-circuit check" begin
            println("Short-circuit check")
            for (unit, reports) in unit_reports
                println("  $(unit.design_dir)")
                @test passed(reports.short_circuit_report.passed == unit.short_circuit_report)
            end
        end
        @testset "Power check" begin
            println("Power check")
            for (unit, reports) in unit_reports
                println("  $(unit.design_dir)")
                @test passed(reports.power_report.passed == unit.power_report)
            end
        end
        @testset "Timing check" begin
            println("Timing check")
            for (unit, reports) in unit_reports
                println("  $(unit.design_dir)")
                @test passed(reports.timing_report.passed == unit.timing_report)
            end
        end
    end
end


#
# Examples
#


function example_counter(;verbose=false)
    # Disguise
    design_dir = joinpath(simple_designs_dir, "counter/outputs_vivado_xilinx_7")
    cell_library = "xilinx_7"
    netlist_fname = joinpath(design_dir, "netlist.json")
    delays_fname = joinpath(design_dir, "delays.sdf")
    
    println("Reading netlist...")
    netlist, lib = read_netlist(netlist_fname_json = netlist_fname,
                                delays_fname_sdf = delays_fname,
                                cell_library = cell_library)

    println("Disguising...")
    disguised_design = disguise_design!(netlist, lib)

    println("Saving design...")
    disguised_path = tempname()
    save_design(disguised_path, disguised_design)


    # Design check    
    println("Loading design...")
    disguised_design = load_design(disguised_path)
    rm(disguised_path)

    if verbose
        print_verbose(disguised_design)
    end

    # Get primary ports
    primary_ports = disguised_design.primary_ports
    if verbose
        println("Primary ports:")
        print_verbose(primary_ports)
    end

    # Add delay and frequency to the clock input
    clk_port = find_single(p -> p["name"] == "clk", primary_ports)
    set_delay!(clk_port, 2e-9) # 2ns
    set_frequency!(clk_port, 100e6) # 100MHz

    if verbose
        print_verbose(disguised_design)
    end
    
    println("Checking...")
    reports = check_design!(disguised_design; primary_port_delay=0, primary_input_freq=500e6, max_fanout_threshold=Inf, average_fanout_threshold=Inf, load_capacitance_source="from_delay", max_dynamic_power_threshold=Inf, total_dynamic_power_threshold=Inf)

    if verbose
        for r in reports
            print_verbose(r)
        end
        println()
    end
end


examples = Dict(
    "counter" => example_counter,
)


test_example(name; kwargs...) = examples[name](;kwargs...)


function test_examples(;kwargs...)
    N = length(examples)
    println("Testing examples...")
    @testset "Examples runtime sanity" begin
        for (i, (name, func)) in enumerate(examples)
            success = try
                print("($i / $N) ")
                println("$name")
                func(;kwargs...)
                true
            catch e
                showerror(stdout, e)
                println()
                false
            end
            @test success
        end
    end    
end
    

end # module CircuitDisguiseTest
