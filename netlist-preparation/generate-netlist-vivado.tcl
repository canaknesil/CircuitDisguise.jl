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


# The commands in this file are to be manually run in Vivado Tcl
# environment to generate a design netlist and an associated SDF
# delays file.


# Generate the design netlist
write_verilog -mode design /path/to/design/xilinx_netlist.v
write_verilog -mode sta /path/to/design/xilinx_netlist_sta.v

# Generate timing delays
write_sdf /path/to/design/delays.sdf


# The structure of the netlist written with 'write_verilog -mode
# design ...' is sometimes different than the specifications produced
# with 'write_sdf ...'. For example, a LUT6_2 cell appear as is in the
# netlist while the delay specifications refer to the LUT5 and LUT6
# cells within the LUT6_2 cell. One solution to ensure compatibility
# is to substitute cells in xilinx_netlist.v, however, supporting all
# possible differences is cumbersome. A second solution is to generate
# the netlist with 'write_verilog -mode sta ...'.
