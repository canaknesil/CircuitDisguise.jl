// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Aug 11 20:48:17 2023
// Host        : DESKTOP-A95ADKL running 64-bit major release  (build 9200)
// Command     : write_verilog -mode design
//               C:/Users/canpi/Documents/repositories/circuit-disguise/simple-designs/transparent_latch_loop/xilinx_netlist.v
// Design      : latch_loop
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a100tftg256-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "60e04341" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module latch_loop
   (en,
    q);
  input en;
  output q;

  wire GND_1;
  wire VCC_1;
  wire a_reg_i_1_n_0;
  wire en;
  wire en_IBUF;
  wire en_IBUF_BUFG;
  wire q;
  wire q_OBUF;

  GND GND
       (.G(GND_1));
  VCC VCC
       (.P(VCC_1));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    a_reg
       (.CLR(GND_1),
        .D(a_reg_i_1_n_0),
        .G(en_IBUF_BUFG),
        .GE(VCC_1),
        .Q(q_OBUF));
  LUT1 #(
    .INIT(2'h1)) 
    a_reg_i_1
       (.I0(q_OBUF),
        .O(a_reg_i_1_n_0));
  BUFG en_IBUF_BUFG_inst
       (.I(en_IBUF),
        .O(en_IBUF_BUFG));
  IBUF #(
    .CCIO_EN("TRUE")) 
    en_IBUF_inst
       (.I(en),
        .O(en_IBUF));
  OBUF q_OBUF_inst
       (.I(q_OBUF),
        .O(q));
endmodule
