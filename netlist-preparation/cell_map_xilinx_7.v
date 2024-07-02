// MIT License

// Copyright (c) 2024 Can Aknesil

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


// This cell library file is used for replacement of some netlist
// cells before disguise.
//
// Example usage: techmap -map <this-file>

// For a LUT6_2 cell in a netlist file, SDF file contains one LUT6 and
// one LUT5. The following mapping makes the netlist to have the same
// structure as the SDF file.

module LUT6_2(output O6, output O5, input I0, I1, I2, I3, I4, I5);
   parameter [63:0] INIT = 0;
   LUT6 #(.INIT(INIT)) LUT6 (
     .O(O6),
     .I0(I0),
     .I1(I1),
     .I2(I2),
     .I3(I3),
     .I4(I4),
     .I5(I5));
   LUT5 #(.INIT(INIT[31:0])) LUT5 (
     .O(O5),
     .I0(I0),
     .I1(I1),
     .I2(I2),
     .I3(I3),
     .I4(I4));
endmodule
