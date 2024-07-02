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
# (cells) gathered from Xilinx documentations.

# The variables defined in this file is used in CellLibraries.jl.


#
# Cell port signal types
#

# Possible signal types are clock, asynchronous, constant, primary, data, and any.

cell_port_signal_types_xilinx_7 = Dict(
    "BUFG" => Dict(
        "I" => "clock",
        "O" => "clock",
    ),
    "BUFGCE" => Dict(
        "CE" => "data",
        "I" => "clock",
        "O" => "clock",
    ),
    "CARRY4" => Dict(
        "O" => "data",
        "CO" => "data",
        "DI" => "data",
        "S" => "data",
        "CYINIT" => "data",
        "CI" => "data",
    ),
    "DSP48E1" => Dict(
        "A"              => "data",
        "ACIN"           => "data",
        "ACOUT"          => "data",
        "ALUMODE"        => "data",
        "B"              => "data",
        "BCIN"           => "data",
        "BCOUT"          => "data",
        "C"              => "data",
        "CARRYCASCIN"    => "data",
        "CARRYCASCOUT"   => "data",
        "CARRYIN"        => "data",
        "CARRYINSEL"     => "data",
        "CARRYOUT"       => "data",
        "CEAD"           => "data",
        "CEALUMODE"      => "data",
        "CEA1"           => "data",
        "CEA2"           => "data",
        "CEB1"           => "data",
        "CEB2"           => "data",
        "CEC"            => "data",
        "CECARRYIN"      => "data",
        "CECTRL"         => "data",
        "CED"            => "data",
        "CEINMODE"       => "data",
        "CEM"            => "data",
        "CEP"            => "data",
        "CLK"            => "clock",
        "D"              => "data",
        "INMODE"         => "data",
        "MULTSIGNIN"     => "data",
        "MULTSIGNOUT"    => "data",
        "OPMODE"         => "data",
        "OVERFLOW"       => "data",
        "P"              => "data",
        "PATTERNBDETECT" => "data",
        "PATTERNDETECT"  => "data",
        "PCIN"           => "data",
        "PCOUT"          => "data",
        "RSTA"           => "data",
        "RSTALLCARRYIN"  => "data",
        "RSTALUMODE"     => "data",
        "RSTB"           => "data",
        "RSTC"           => "data",
        "RSTCTRL"        => "data",
        "RSTD"           => "data",
        "RSTINMODE"      => "data",
        "RSTM"           => "data",
        "RSTP"           => "data",
        "UNDERFLOW"      => "data",
    ),
    "FDCE" => Dict(
        "D" => "data",
        "CE" => "data",
        "C" => "clock",
        "CLR" => "asynchronous",
        "Q" => "data",
    ),
    "FDRE" => Dict(
        "D" => "data",
        "CE" => "data",
        "C" => "clock",
        "R" => "asynchronous",
        "Q" => "data",
    ),
    "GND" => Dict(
        "G" => "constant",
    ),
    "IBUF" => Dict(
        "I" => "primary",
        "O" => "primary",
    ),
    "LDCE" => Dict(
        "D" => "data",
        "GE" => "data",
        "G" => "clock",
        "CLR" => "asynchronous",
        "Q" => "data",
    ),
    "LUT1" => Dict(
        "I0" => "data",
        "O" => "data",
    ),
    "LUT2" => Dict(
        "I0" => "data",
        "I1" => "data",
        "O" => "data",
    ),
    "LUT3" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "O" => "data",
    ),
    "LUT4" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "I3" => "data",
        "O" => "data",
    ),
    "LUT5" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "I3" => "data",
        "I4" => "data",
        "O" => "data",
    ),
    "LUT6" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "I3" => "data",
        "I4" => "data",
        "I5" => "data",
        "O" => "data",
    ),
    "MUXF7" => Dict(
        "I0" => "data",
        "I1" => "data",
        "S" => "data",
        "O" => "data",
    ),
    "MUXF8" => Dict(
        "I0" => "data",
        "I1" => "data",
        "S" => "data",
        "O" => "data",
    ),    
    "OBUF" => Dict(
        "I" => "primary",
        "O" => "primary",
    ),
    "VCC" => Dict(
        "P" => "constant",
    ),
    # TODO: Complete the list cell_port_signal_types_xilinx_7
)


#
# Cell port directions
#

# Currently, port directions are infered from
# lib_xilinx_7.json. cell_port_directions_xilinx_7 can still be used
# to provide additional information or overwrite existing information.

# Possible directions are input and output.

cell_port_directions_xilinx_7 = Dict(
    "BUFGCE" => Dict(
        "CE" => "input",
        "I" => "input",
        "O" => "output",
    ),
)


#
# Cell IO paths
#

# Additional IO paths that is not defined in SDF file.

# (src_port_name, bus_index, dst_port_name, bus_index)
# bus_index is nothing if port is not a bus, or the specification applies all bits.

cell_io_paths_xilinx_7 = Dict()


#
# Cell ineffective IO paths functions
#

cell_ineffective_io_paths_funcs_xilinx_7 = Dict(
    "LUT1" => (params -> cell_ineffective_io_paths_func_lut_k(1, params)),
    "LUT2" => (params -> cell_ineffective_io_paths_func_lut_k(2, params)),
    "LUT3" => (params -> cell_ineffective_io_paths_func_lut_k(3, params)),
    "LUT4" => (params -> cell_ineffective_io_paths_func_lut_k(4, params)),
    "LUT5" => (params -> cell_ineffective_io_paths_func_lut_k(5, params)),
    "LUT6" => (params -> cell_ineffective_io_paths_func_lut_k(6, params)),
)
