// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2.2 (lin64) Build 3118627 Tue Feb  9 05:13:49 MST 2021
// Date        : Mon Aug  7 16:02:03 2023
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design
//               /home/canaknesil/Documents/repos/circuit-disguise/designs/lut6x2/xilinx_netlist.v
// Design      : lut6x2
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tftg256-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "27fd088c" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module lut6x2
   (a,
    q1,
    q2);
  input [4:0]a;
  output q1;
  output q2;

  wire \<const1> ;
  wire [4:0]a;
  wire [4:0]a_IBUF;
  wire q1;
  wire q1_OBUF;
  wire q2;
  wire q2_OBUF;

  (* box_type = "PRIMITIVE" *) 
  LUT6_2 #(
    .INIT(64'h6996966996696996)) 
    LUT6_2_inst
       (.I0(a_IBUF[0]),
        .I1(a_IBUF[1]),
        .I2(a_IBUF[2]),
        .I3(a_IBUF[3]),
        .I4(a_IBUF[4]),
        .I5(\<const1> ),
        .O5(q1_OBUF),
        .O6(q2_OBUF));
  VCC VCC
       (.P(\<const1> ));
  IBUF \a_IBUF[0]_inst 
       (.I(a[0]),
        .O(a_IBUF[0]));
  IBUF \a_IBUF[1]_inst 
       (.I(a[1]),
        .O(a_IBUF[1]));
  IBUF \a_IBUF[2]_inst 
       (.I(a[2]),
        .O(a_IBUF[2]));
  IBUF \a_IBUF[3]_inst 
       (.I(a[3]),
        .O(a_IBUF[3]));
  IBUF \a_IBUF[4]_inst 
       (.I(a[4]),
        .O(a_IBUF[4]));
  OBUF q1_OBUF_inst
       (.I(q1_OBUF),
        .O(q1));
  OBUF q2_OBUF_inst
       (.I(q2_OBUF),
        .O(q2));
endmodule
