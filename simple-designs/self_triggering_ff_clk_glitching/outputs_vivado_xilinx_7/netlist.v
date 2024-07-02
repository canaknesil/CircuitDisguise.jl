// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2.2 (lin64) Build 3118627 Tue Feb  9 05:13:49 MST 2021
// Date        : Tue Sep  5 12:13:38 2023
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design -force
//               /home/canaknesil/Documents/repos/circuit-disguise/simple-designs/self_triggering_ff/xilinx_netlist.v
// Design      : self_triggering_ff
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tftg256-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "48939534" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module self_triggering_ff
   (en,
    reset,
    q);
  input en;
  input reset;
  output q;

  wire \<const1> ;
  (* DONT_TOUCH *) wire a;
  (* DONT_TOUCH *) wire b;
  (* DONT_TOUCH *) wire clk;
  wire en;
  wire en_IBUF;
  wire p_1_in;
  wire q;
  wire reset;
  wire reset_IBUF;

  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1)) 
    a_i_1
       (.I0(a),
        .O(p_1_in));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    a_reg
       (.C(clk),
        .CE(\<const1> ),
        .CLR(reset_IBUF),
        .D(p_1_in),
        .Q(a));
  LUT1 #(
    .INIT(2'h2)) 
    b_inst
       (.I0(a),
        .O(b));
  LUT3 #(
    .INIT(8'h96)) 
    clk_inferred_i_1
       (.I0(b),
        .I1(a),
        .I2(en_IBUF),
        .O(clk));
  IBUF en_IBUF_inst
       (.I(en),
        .O(en_IBUF));
  OBUF q_OBUF_inst
       (.I(a),
        .O(q));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
