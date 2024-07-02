// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2.2 (lin64) Build 3118627 Tue Feb  9 05:13:49 MST 2021
// Date        : Tue Nov 28 12:25:32 2023
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design
//               /home/canaknesil/Documents/repos/circuit-disguise/simple-designs/short_circuit/xilinx_netlist.v
// Design      : top
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tftg256-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module top
   (a,
    b,
    c);
  input a;
  input b;
  output c;

  wire a;
  wire b;
  wire c;
  wire c_OBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(c_OBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(c_OBUF));
  OBUF c_OBUF_inst
       (.I(c_OBUF),
        .O(c));
endmodule
