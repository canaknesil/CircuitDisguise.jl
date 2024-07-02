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


# This module should be able to run without the CircuitDisguise
# package installed.

module NetlistPreparation

export convert_cell_library, convert_netlist_vivado, convert_netlist_other, convert_netlist


# Yosys scripts doesn't support command line arguments, so creating
# the scripts in Julia.
    

netlist_preparation_dir = joinpath(@__DIR__, "../netlist-preparation")


function check_yosys()
    if isnothing(Sys.which("yosys"))
        error("Yosys is not available!")
    end
end


"""
    convert_cell_library(verilog_fname::AbstractString)

Convert cell library in Verilog into a format suitable for
`CircuitDisguise`. Return `true` on success, `false` otherwise.

"""
function convert_cell_library(lib_prefix::AbstractString)
    check_yosys()

    verilog_fname = lib_prefix * ".v"
    rtlil_fname = lib_prefix * ".rtlil"
    json_fname = lib_prefix * ".json"

    commands  = "read_verilog $verilog_fname; "
    commands *= "write_rtlil $rtlil_fname; "

    # JSON backend doesn't support processess.
    commands *= "proc; "    
    
    commands *= "write_json $json_fname"

    println("Running Yosys commands: $commands")

    status = success(run(`yosys -g -p "$commands"`))
    return status
end


"""
    convert_netlist_vivado(netlist_prefix::AbstractString, lib::AbstractString; top::AbstractString="")

Convert netlist `<netlist_prefix>.v` to a format suitable for
`CircuitDisguise`. The netlist is expected to be generated using the
`write_netlist -mode design ...` command in Vivado. After the
conversion, `<netlist_prefix>.json` is created in the same
directory. Return `true` on success, `false` otherwise.

Optional keyword argument `top` can be used to specify the top
module. Otherwise, the top module is inferred.

The conversion includes cell substitution to ensure compatibility with
the SDF delay specifications. If the netlist was generated with `-mode
sta` option, `convert_netlist` should be used instead.

"""
function convert_netlist_vivado(netlist_prefix::AbstractString, lib::AbstractString; top::AbstractString="")
    check_yosys()

    if lib == "xilinx_7"
        map_file = joinpath(netlist_preparation_dir, "cell_map_xilinx_7.v")
    elseif lib == "xilinx_ultrascale"
        map_file = joinpath(netlist_preparation_dir, "cell_map_xilinx_ultrascale.v")
    else
        error("Unsupported cell library $lib!")
    end

    verilog_fname = netlist_prefix * ".v"
    rtlil_fname = netlist_prefix * ".rtlil"
    json_fname = netlist_prefix * ".json"

    # Load the verilog source files to AST representation.
    commands  = "read -sv $(verilog_fname); "

    # Generate RTLIL representation of the module.
    if top == ""
        commands *= "hierarchy -auto-top; "
    else
        commands *= "hierarchy -top $top; "
    end
    
    commands *= "flatten; "
    commands *= "techmap -map $map_file; "

    # Write Xilinx netlist in other formats.
    commands *= "write_rtlil $rtlil_fname; "
    commands *= "write_json $json_fname"

    println("Running Yosys commands: $commands")

    status = success(run(`yosys -g -p "$commands"`))
    return status
end


"""
    convert_netlist_other(netlist_prefix::AbstractString; top::AbstractString="")

Convert netlist `<netlist_prefix>.v` to a format suitable for
`CircuitDisguise`. After the conversion `<netlist_prefix>.json` is
created in the same directory. Return `true` on success, `false`
otherwise.

Optional keyword argument `top` can be used to specify the top
module. Otherwise, the top module is inferred.

"""
function convert_netlist_other(netlist_prefix::AbstractString; top::AbstractString="")
    check_yosys()

    verilog_fname = netlist_prefix * ".v"
    rtlil_fname = netlist_prefix * ".rtlil"
    json_fname = netlist_prefix * ".json"

    # Load the verilog source files to AST representation.
    commands  = "read -sv $(verilog_fname); "

    # Generate RTLIL representation of the module.
    if top == ""
        commands *= "hierarchy -auto-top; "
    else
        commands *= "hierarchy -top $top; "
    end
    
    commands *= "flatten; "

    # Write converted netlist in other formats.
    commands *= "write_rtlil $(rtlil_fname); "
    commands *= "write_json $(json_fname)"

    println("Running Yosys commands: $commands")

    status = success(run(`yosys -g -p "$commands"`))
    return status
end


"""
    convert_netlist(netlist_prefix::AbstractString,
                    design_tool::AbstractString,
                    lib::AbstractString;
                    top::AbstractString="")

Convert netlist `<netlist_prefix>.v` to a format suitable for
`CircuitDisguise`. If `design_tool` is `"vivado"`, the netlist is
expected to be generated using the `write_netlist -mode design ...`
Tcl command. After the conversion, `<netlist_prefix>.json` is created
in the same directory. Return `true` on success, `false` otherwise.

Optional keyword argument `top` can be used to specify the top
module. Otherwise, the top module is inferred.

If `design_tool` is `"vivado"`, the conversion includes cell
substitution to ensure compatibility with the SDF delay
specifications. If the netlist was generated with `-mode sta` option,
`convert_netlist_other` should be used instead.

"""
function convert_netlist(netlist_dir::AbstractString, design_tool::AbstractString, lib::AbstractString; top::AbstractString="")
    check_yosys()

    println("Converting netlist at $netlist_dir ...")

    netlist_prefix = joinpath(netlist_dir, "netlist")
    netlist_fname = netlist_prefix * ".v"

    @assert isfile(netlist_fname)
    
    if design_tool == "vivado"
        status = convert_netlist_vivado(netlist_prefix, lib; top)
    else
        status = convert_netlist_other(netlist_prefix; top)
    end

    println("\nConverting netlist at $netlist_dir DONE.")
    return status
end


end # module NetlistPreparation
