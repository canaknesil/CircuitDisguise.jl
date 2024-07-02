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


module CellLibraries

using ..Util
import JSON

export CellLibrary, get_port_direction, get_port_signal_type, get_io_paths, get_ineffective_io_paths, make_cell_library


cell_library_dir = joinpath(@__DIR__, "../fpga-libraries/")

# Following code files define variables that are used in this module.
include(joinpath(cell_library_dir, "lib_additions_utils.jl"))
include(joinpath(cell_library_dir, "lib_xilinx_7_additions.jl"))
include(joinpath(cell_library_dir, "lib_xilinx_7_vpr_additions.jl"))
include(joinpath(cell_library_dir, "lib_xilinx_ultrascale_additions.jl"))
include(joinpath(cell_library_dir, "lib_vpr_additions.jl"))


#
# Cell library information data structure: Stores information about FPGA resources to be used during disguise.
#

"Cell library type that contains information of available resources of an FPGA."
struct CellLibrary
    info
end

CellLibrary() = CellLibrary(Dict())

"Get cell port direction from cell library."
function get_port_direction(lib::CellLibrary, cell_type, port_name)
    if !haskey(lib.info, cell_type)
        error("Cell type $cell_type is not in cell library!")
    end
    if !haskey(lib.info[cell_type], "ports")
        error("Cell type $cell_type doesn't have \"ports\" key!")
    end
    if !haskey(lib.info[cell_type]["ports"], port_name)
        error("Cell type $cell_type doesn't have port $(port_name)!")
    end
    return lib.info[cell_type]["ports"][port_name]["direction"]
end

"Get cell port signal type from cell library."
function get_port_signal_type(lib::CellLibrary, cell_type, port_name)
    if (haskey(lib.info, cell_type) &&
        haskey(lib.info[cell_type], "ports") &&
        haskey(lib.info[cell_type]["ports"], port_name) &&
        haskey(lib.info[cell_type]["ports"][port_name], "signal_type"))
    
        return lib.info[cell_type]["ports"][port_name]["signal_type"]
    else
        println("Warning: Signal type of $(cell_type).$(port_name) is not in the cell library. Assuming data.")
        return "data"
    end
end

"Get cell io paths from cell library."
function get_io_paths(lib::CellLibrary, cell_type)
    if (haskey(lib.info, cell_type) &&
        haskey(lib.info[cell_type], "io_paths"))
    
        return lib.info[cell_type]["io_paths"]
    else
        return nothing
    end
end

"Return IO paths of a cell where the input does not effect the output, according to cell parameters."
function get_ineffective_io_paths(lib::CellLibrary, cell_type, cell_parameters)
    if !haskey(lib.info, cell_type)
        error("Cell type $cell_type is not in cell library!")
    end
    if haskey(lib.info[cell_type], "ineffective_io_paths_func")
        return lib.info[cell_type]["ineffective_io_paths_func"](cell_parameters)
    else
        return []
    end
end


#
# Cell information from Yosys library file.
# Cell port directions
#

cell_library_fname_json = Dict(
    "xilinx_7"     => joinpath(cell_library_dir, "lib_xilinx_7.json"),
    "xilinx_7_vpr" => joinpath(cell_library_dir, "lib_xilinx_7_vpr.json"),
    "vpr" => joinpath(cell_library_dir, "lib_vpr.json"),
)

"Read cell library file written in JSON format by Yosys. Return information about the available cells."
function read_cell_library_json!(lib::CellLibrary, fname::AbstractString)
    j = JSON.parsefile(fname)
    info = lib.info
    
    modules = j["modules"]
    for (cell_type, cell) in modules
        set_if_unset!(info, cell_type, Dict())
        set_if_unset!(info[cell_type], "ports", Dict())
        ports = cell["ports"]
        for (port_name, attributes) in ports
            set_if_unset!(info[cell_type]["ports"], port_name, Dict())
            info[cell_type]["ports"][port_name]["direction"] = attributes["direction"]
        end
    end
end


#
# Cell port directions
#

# Defined in lib_<series>_additions.jl:
# cell_port_directions_<series>

cell_port_directions = Dict(
    "xilinx_7" => cell_port_directions_xilinx_7,
    "xilinx_7_vpr" => cell_port_directions_xilinx_7_vpr,
    "xilinx_ultrascale" => cell_port_directions_xilinx_ultrascale,
    "vpr" => cell_port_directions_vpr,
)

function add_cell_port_directions!(lib::CellLibrary, info::AbstractDict)
    for (cell_type, cell_info) in pairs(info)
        lib_cell_info = set_if_unset!(lib.info, cell_type, Dict())
        for (port_name, dir) in pairs(cell_info)
            set_if_unset!(lib_cell_info, "ports", Dict())
            lib_port_info = set_if_unset!(lib_cell_info["ports"], port_name, Dict())
            lib_port_info["direction"] = dir
        end
    end
end


#
# Cell port signal types
#

# Defined in lib_<series>_additions.jl:
# cell_port_signal_types_<series>

cell_port_signal_types = Dict(
    "xilinx_7" => cell_port_signal_types_xilinx_7,
    "xilinx_7_vpr" => cell_port_signal_types_xilinx_7_vpr,
    "xilinx_ultrascale" => cell_port_signal_types_xilinx_ultrascale,
    "vpr" => cell_port_signal_types_vpr,
)

function add_cell_port_signal_types!(lib::CellLibrary, info::AbstractDict)
    for (cell_type, cell_info) in pairs(info)
        lib_cell_info = set_if_unset!(lib.info, cell_type, Dict())
        for (port_name, signal_type) in pairs(cell_info)
            set_if_unset!(lib_cell_info, "ports", Dict())
            lib_port_info = set_if_unset!(lib_cell_info["ports"], port_name, Dict())
            lib_port_info["signal_type"] = signal_type
        end
    end
end


#
# Cell IO paths
#

# Defined in lib_<series>_additions.jl:
# cell_io_paths_<series>

cell_io_paths = Dict(
    "xilinx_7" => cell_io_paths_xilinx_7,
    "xilinx_7_vpr" => cell_io_paths_xilinx_7_vpr,
    "xilinx_ultrascale" => cell_io_paths_xilinx_ultrascale,
    "vpr" => cell_io_paths_vpr,
)

function add_cell_io_paths!(lib::CellLibrary, info::AbstractDict)
    for (cell_type, paths) in pairs(info)
        lib_cell_info = set_if_unset!(lib.info, cell_type, Dict())
        lib_cell_info["io_paths"] = paths
    end
end


#
# Cell ineffective IO paths functions
#

cell_ineffective_io_paths_funcs = Dict(
    "xilinx_7" => cell_ineffective_io_paths_funcs_xilinx_7,
    "xilinx_7_vpr" => Dict(),
    "xilinx_ultrascale" => cell_ineffective_io_paths_funcs_xilinx_ultrascale,
    "vpr" => Dict(),
)

function add_cell_ineffective_io_paths_funcs!(lib::CellLibrary, info::AbstractDict)
    for (cell_type, func) in pairs(info)
        lib_cell_info = set_if_unset!(lib.info, cell_type, Dict())
        lib_cell_info["ineffective_io_paths_func"] = func
    end
end


#
# Compile cell library from available sources
#

"Compile cell library from available sources."
function make_cell_library(cell_library::AbstractString)
    lib = CellLibrary()

    if (cell_library == "xilinx_7"
        || cell_library == "xilinx_7_vpr"
        || cell_library == "vpr")
        
        read_cell_library_json!(lib, cell_library_fname_json[cell_library])
    end
    add_cell_port_directions!(lib, cell_port_directions[cell_library])
    add_cell_port_signal_types!(lib, cell_port_signal_types[cell_library])
    add_cell_io_paths!(lib, cell_io_paths[cell_library])
    add_cell_ineffective_io_paths_funcs!(lib, cell_ineffective_io_paths_funcs[cell_library])

    return lib
end


end # module CellLibraries
