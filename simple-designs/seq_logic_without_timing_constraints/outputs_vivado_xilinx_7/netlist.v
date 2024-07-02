// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Tue Aug  8 15:06:30 2023
// Host        : DESKTOP-A95ADKL running 64-bit major release  (build 9200)
// Command     : write_verilog -mode design
//               C:/Users/canpi/Documents/repositories/circuit-disguise/designs/seq_logic_without_timing_constraints/xilinx_netlist.v
// Design      : seq_logic
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a100tftg256-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "273096b2" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module seq_logic
   (clk,
    reset,
    q);
  input clk;
  input reset;
  output q;

  wire \<const1> ;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire p_0_in;
  wire q;
  wire q_OBUF;
  wire reset;
  wire reset_IBUF;

  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1)) 
    a_i_1
       (.I0(q_OBUF),
        .O(p_0_in));
  FDCE #(
    .INIT(1'b0)) 
    a_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(reset_IBUF),
        .D(p_0_in),
        .Q(q_OBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF #(
    .CCIO_EN("TRUE")) 
    clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF q_OBUF_inst
       (.I(q_OBUF),
        .O(q));
  IBUF #(
    .CCIO_EN("TRUE")) 
    reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
