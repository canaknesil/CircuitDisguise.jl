// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2.2 (lin64) Build 3118627 Tue Feb  9 05:13:49 MST 2021
// Date        : Tue Sep  5 16:11:51 2023
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design
//               /home/canaknesil/Documents/repos/circuit-disguise/simple-designs/signal_distribution/xilinx_netlist.v
// Design      : signal_distribution
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tftg256-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "65e29547" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module signal_distribution
   (x,
    q);
  input x;
  output q;

  (* DONT_TOUCH *) wire [0:2]a2;
  (* DONT_TOUCH *) wire [0:8]b2;
  wire q;
  wire q_OBUF;
  wire q_OBUF_inst_i_2_n_0;
  wire x;
  wire x_IBUF;

  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[0].GEN_2[0].LUT1_inst 
       (.I0(a2[0]),
        .O(b2[0]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[0].GEN_2[1].LUT1_inst 
       (.I0(a2[0]),
        .O(b2[1]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[0].GEN_2[2].LUT1_inst 
       (.I0(a2[0]),
        .O(b2[2]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[0].LUT1_inst 
       (.I0(x_IBUF),
        .O(a2[0]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[1].GEN_2[0].LUT1_inst 
       (.I0(a2[1]),
        .O(b2[3]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[1].GEN_2[1].LUT1_inst 
       (.I0(a2[1]),
        .O(b2[4]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[1].GEN_2[2].LUT1_inst 
       (.I0(a2[1]),
        .O(b2[5]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[1].LUT1_inst 
       (.I0(x_IBUF),
        .O(a2[1]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[2].GEN_2[0].LUT1_inst 
       (.I0(a2[2]),
        .O(b2[6]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[2].GEN_2[1].LUT1_inst 
       (.I0(a2[2]),
        .O(b2[7]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[2].GEN_2[2].LUT1_inst 
       (.I0(a2[2]),
        .O(b2[8]));
  (* box_type = "PRIMITIVE" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GEN_1[2].LUT1_inst 
       (.I0(x_IBUF),
        .O(a2[2]));
  OBUF q_OBUF_inst
       (.I(q_OBUF),
        .O(q));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    q_OBUF_inst_i_1
       (.I0(b2[0]),
        .I1(q_OBUF_inst_i_2_n_0),
        .I2(b2[2]),
        .I3(b2[1]),
        .I4(b2[4]),
        .I5(b2[3]),
        .O(q_OBUF));
  LUT4 #(
    .INIT(16'h6996)) 
    q_OBUF_inst_i_2
       (.I0(b2[6]),
        .I1(b2[5]),
        .I2(b2[8]),
        .I3(b2[7]),
        .O(q_OBUF_inst_i_2_n_0));
  IBUF x_IBUF_inst
       (.I(x),
        .O(x_IBUF));
endmodule
