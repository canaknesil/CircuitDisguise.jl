// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Fri Mar 15 11:58:59 2024
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design
//               /home/canaknesil/Documents/repos/circuit-disguise/simple-designs/internal_clock_generation/outputs_vivado_xilinx_ultrascale/netlist.v
// Design      : top
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xazu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_divider
   (new_clk,
    clk_IBUF_BUFG,
    reset_IBUF);
  output new_clk;
  input clk_IBUF_BUFG;
  input reset_IBUF;

  wire \<const1> ;
  wire clk_IBUF_BUFG;
  wire count;
  wire new_clk;
  wire new_clk_i_1_n_0;
  wire p_0_in;
  wire reset_IBUF;

  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \count[0]_i_1 
       (.I0(count),
        .O(p_0_in));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(reset_IBUF),
        .D(p_0_in),
        .Q(count));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    new_clk_i_1
       (.I0(count),
        .I1(new_clk),
        .O(new_clk_i_1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    new_clk_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(reset_IBUF),
        .D(new_clk_i_1_n_0),
        .Q(new_clk));
endmodule

(* ECO_CHECKSUM = "d859d9e8" *) 
(* STRUCTURAL_NETLIST = "yes" *)
(* \DesignAttr:ENABLE_NOC_NETLIST_VIEW  *) 
(* \DesignAttr:ENABLE_AIE_NETLIST_VIEW  *) 
module top
   (clk,
    reset,
    q);
  input clk;
  input reset;
  output q;

  wire \<const1> ;
  wire VCC_2;
  wire a;
  wire a_i_1_n_0;
  wire b;
  wire b_i_1_n_0;
  wire clk;
  wire clk_IBUF;
  (* MAX_PROG_DELAY = "0" *) wire clk_IBUF_BUFG;
  wire new_clk;
  wire q;
  wire q_OBUF;
  wire reset;
  wire reset_IBUF;

  clock_divider CD
       (.clk_IBUF_BUFG(clk_IBUF_BUFG),
        .new_clk(new_clk),
        .reset_IBUF(reset_IBUF));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  LUT1 #(
    .INIT(2'h1)) 
    a_i_1
       (.I0(a),
        .O(a_i_1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    a_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(reset_IBUF),
        .D(a_i_1_n_0),
        .Q(a));
  LUT1 #(
    .INIT(2'h1)) 
    b_i_1
       (.I0(b),
        .O(b_i_1_n_0));
  FDCE #(
    .INIT(1'b0)) 
    b_reg
       (.C(new_clk),
        .CE(\<const1> ),
        .CLR(reset_IBUF),
        .D(b_i_1_n_0),
        .Q(b));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS"),
    .STARTUP_SYNC("FALSE")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_2),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF q_OBUF_inst
       (.I(q_OBUF),
        .O(q));
  LUT2 #(
    .INIT(4'h8)) 
    q_OBUF_inst_i_1
       (.I0(a),
        .I1(b),
        .O(q_OBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
