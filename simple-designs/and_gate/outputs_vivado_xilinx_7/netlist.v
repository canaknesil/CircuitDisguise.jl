// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2.2 (lin64) Build 3118627 Tue Feb  9 05:13:49 MST 2021
// Date        : Fri Jun 16 11:10:23 2023
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design /home/canaknesil/Documents/work/circuit-disguise-work/and-gate_netlist.v
// Design      : circuit_disguise_top
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "1f88fa07" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module circuit_disguise_top
   (a,
    b,
    c);
  input a;
  input b;
  output c;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire c;
  wire c_OBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  OBUF c_OBUF_inst
       (.I(c_OBUF),
        .O(c));
  LUT2 #(
    .INIT(4'h8)) 
    c_OBUF_inst_i_1
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .O(c_OBUF));
endmodule
