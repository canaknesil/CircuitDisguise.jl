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


`timescale 1ns / 1ps

module top(x, y);
    input x;
    output y;
    
    (* dont_touch = "yes" *) wire a;
    
    LUT6_2 #(
       .INIT(64'hAAAAAAAAAAAAAAAA) // Specify LUT Contents
    ) LUT6_2_inst (
       .O6(a), // 1-bit LUT6 output
       .O5(y), // 1-bit lower LUT5 output
       .I0(x), // 1-bit LUT input
       .I1(a), // 1-bit LUT input
       .I2(0), // 1-bit LUT input
       .I3(0), // 1-bit LUT input
       .I4(0), // 1-bit LUT input
       .I5(0)  // 1-bit LUT input (fast MUX select only available to O6 output)
    );
endmodule
