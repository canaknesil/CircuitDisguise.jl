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
# (cells) gathered from VPR documentations.

# The variables defined in this file is used in CellLibraries.jl.


#
# Cell port signal types
#

# Extend/overwrite the information existing in cell_port_signal_types_xilinx_7.

# Possible signal types are clock, asynchronous, constant, primary, data, and any.

cell_port_signal_types_xilinx_7_vpr = deepcopy(cell_port_signal_types_xilinx_7)
push!(
    cell_port_signal_types_xilinx_7_vpr,
    "CE_VCC" => Dict(
        "VCC" => "constant",
    ),
    "CARRY_COUT_PLUG" => Dict(
        "CIN" => "data",
        "COUT" => "data",
    ),
    "CARRY4_VPR" => Dict(
        "O0" => "data",
        "O1" => "data",
        "O2" => "data",
        "O3" => "data",
        "CO0" => "data",
        "CO1" => "data",
        "CO2" => "data",
        "CO3" => "data",
        "CYINIT" => "data",
        "CIN" => "data",
        "DI0" => "data",
        "DI1" => "data",
        "DI2" => "data",
        "DI3" => "data",
        "S0" => "data",
        "S1" => "data",
        "S2" => "data",
        "S3" => "data",
    ),
    "DPRAM32" => Dict(
        "DI" => "data",
        "CLK" => "clock",
        "WE" => "data",
        "A" => "data",
        "WA" => "data",
        "O" => "data",
    ),
    "DPRAM64" => Dict(
        "DI" => "data",
        "CLK" => "clock",
        "WE" => "data",
        "WA7" => "data",
        "WA8" => "data",
        "A" => "data",
        "WA" => "data",
        "O" => "data",
    ),
    "DRAM_8_OUTPUT_STUB" => Dict(
        "DOA1" => "data",
        "DOB1" => "data",
        "DOC1" => "data",
        "DOD1" => "data",
        "DOA0" => "data",
        "DOB0" => "data",
        "DOC0" => "data",
        "DOD0" => "data",
        "DOA1_OUT" => "data",
        "DOB1_OUT" => "data",
        "DOC1_OUT" => "data",
        "DOD1_OUT" => "data",
        "DOA0_OUT" => "data",
        "DOB0_OUT" => "data",
        "DOC0_OUT" => "data",
        "DOD0_OUT" => "data",
    ),
    "FDCE_ZINI" => Dict(
        "C" => "clock",
        "CE" => "data",
        "D" => "data",
        "CLR" => "async",
        "Q" => "data",
    ),
    "FDPE_ZINI" => Dict(
        "C" => "clock",
        "CE" => "data",
        "D" => "data",
        "PRE" => "async",
        "Q" => "data",
    ),
    "FDRE_ZINI" => Dict(
        "C" => "clock",
        "CE" => "data",
        "D" => "data",
        "R" => "data",
        "Q" => "data",
    ),
    "FDSE_ZINI" => Dict(
        "C" => "clock",
        "CE" => "data",
        "D" => "data",
        "S" => "data",
        "Q" => "data",
    ),
    "fpga_interconnect" => Dict(
        "datain" => "any",
        "dataout" => "any",
    ),
    "GND" => Dict(
        "GND" => "constant",
    ),
    "IBUF_VPR" => Dict(
        "I" => "primary",
        "O" => "primary",
    ),
    "LUT_K" => Dict(
        "in" => "data",
        "out" => "data",
    ),
    "MUXF5" => Dict(
        "I0" => "data",
        "I1" => "data",
        "S" => "data",
        "O" => "data",
    ),
    "MUXF6" => Dict(
        "I0" => "data",
        "I1" => "data",
        "S" => "data",
        "O" => "data",
    ),
    "OBUFT_VPR" => Dict(
        "I" => "primary",
        "T" => "data",
        "O" => "primary",
    ),
    "SPRAM32" => Dict(
        "DI" => "data",
        "CLK" => "clock",
        "WE" => "data",
        "A" => "data",
        "WA" => "data",
        "O" => "data",
    ),
    "SR_GND" => Dict(
        "GND" => "constant",
    ),
    "T_INV" => Dict(
        "TI" => "data",
        "TO" => "data",
    ),
    "VCC" => Dict(
        "VCC" => "constant",
    ),
    
    # TODO: Complete the list cell_port_signal_types_xilinx_7_vpr
)


#
# Cell port directions
#

# Currently, port directions are infered from
# lib_xilinx_7_vpr.json. cell_port_directions_xilinx_7_vpr can still
# be used to provide additional information or overwrite existing
# information.

# Extend/overwrite the information existing in cell_port_directions_xilinx_7.

# Possible directions are input and output.

cell_port_directions_xilinx_7_vpr = deepcopy(cell_port_directions_xilinx_7)
# push!(
#     cell_port_directions_xilinx_7_vpr,
#     # ...
# )


#
# Cell IO paths
#

# Additional IO paths that is not defined in SDF file.

# (src_port_name, bus_index, dst_port_name, bus_index)
# bus_index is nothing if port is not a bus, or the specification applies all bits.

cell_io_paths_xilinx_7_vpr = deepcopy(cell_io_paths_xilinx_7)
push!(
    cell_io_paths_xilinx_7_vpr,
    # When compiling aes_core with F4PGA, IO path of IBUF_VPR cell
    # from which the clock signal passes is not defined in SDF file.
    "IBUF_VPR" => [
        ("I", nothing, "O", nothing),
    ],
)
