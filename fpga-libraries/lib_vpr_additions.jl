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


# This file contains additional information of FPGA design elements
# (cells) gathered from vendor documentations.

# The variables defined in this file is used in CellLibraries.jl.


#
# Cell port signal types
#

# Possible signal types are clock, asynchronous, constant, primary, data, and any.

cell_port_signal_types_vpr = Dict(
    "adder" => Dict(
        "cin" => "data",
        "a" => "data",
        "b" => "data",
        "sumout" => "data",
        "cout" => "data",
    ),
    "DFF" => Dict(
        "clock" => "clock",
        "D" => "data",
        "Q" => "data",
    ),
    "fpga_interconnect" => Dict(
        "datain" => "any",
        "dataout" => "any",
    ),
    "LUT_K" => Dict(
        "in" => "data",
        "out" => "data",
    ),
    # TODO: Complete cell_port_signal_types_vpr
)


#
# Cell port directions
#

# Currently, port directions are infered from
# lib_vpr.json. cell_port_directions_vpr can still be used to provide
# additional information or overwrite existing information.

# Possible directions are input and output.

cell_port_directions_vpr = Dict(
    # Existing VPR primitives has inconsistency in port names. Designs
    # synthesized with VTR has the port DFF.clock, while the cell
    # library has DFF.clk.
    "DFF" => Dict(
        "clock" => "input",
        "D" => "input",
        "Q" => "output",
    ),
)


#
# Cell IO paths
#

# Additional IO paths that is not defined in SDF file.

# (src_port_name, bus_index, dst_port_name, bus_index)
# bus_index is nothing if port is not a bus, or the specification applies all bits.

cell_io_paths_vpr = Dict()

