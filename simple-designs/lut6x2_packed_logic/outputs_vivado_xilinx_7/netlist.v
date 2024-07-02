// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2.2 (lin64) Build 3118627 Tue Feb  9 05:13:49 MST 2021
// Date        : Mon Aug  7 15:04:44 2023
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design
//               /home/canaknesil/Documents/repos/circuit-disguise/designs/lut6x2_packed_logic/xilinx_netlist.v
// Design      : lut6x2
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tftg256-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "6c9f3371" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module lut6x2
   (a1,
    a2,
    a3,
    b1,
    b2,
    q1,
    q2);
  input a1;
  input a2;
  input a3;
  input b1;
  input b2;
  output q1;
  output q2;

  wire \<const1> ;
  wire a1;
  wire a1_IBUF;
  wire a2;
  wire a2_IBUF;
  wire a3;
  wire a3_IBUF;
  wire b1;
  wire b1_IBUF;
  wire b2;
  wire b2_IBUF;
  wire q1;
  wire q1_OBUF;
  wire q2;
  wire q2_OBUF;

  (* box_type = "PRIMITIVE" *) 
  LUT6_2 #(
    .INIT(64'h6969696900FFFF00)) 
    LUT6_2_inst
       (.I0(a1_IBUF),
        .I1(a2_IBUF),
        .I2(a3_IBUF),
        .I3(b1_IBUF),
        .I4(b2_IBUF),
        .I5(\<const1> ),
        .O5(q1_OBUF),
        .O6(q2_OBUF));
  VCC VCC
       (.P(\<const1> ));
  IBUF a1_IBUF_inst
       (.I(a1),
        .O(a1_IBUF));
  IBUF a2_IBUF_inst
       (.I(a2),
        .O(a2_IBUF));
  IBUF a3_IBUF_inst
       (.I(a3),
        .O(a3_IBUF));
  IBUF b1_IBUF_inst
       (.I(b1),
        .O(b1_IBUF));
  IBUF b2_IBUF_inst
       (.I(b2),
        .O(b2_IBUF));
  OBUF q1_OBUF_inst
       (.I(q1_OBUF),
        .O(q1));
  OBUF q2_OBUF_inst
       (.I(q2_OBUF),
        .O(q2));
endmodule
