// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Tue Aug  8 11:43:39 2023
// Host        : DESKTOP-A95ADKL running 64-bit major release  (build 9200)
// Command     : write_verilog -mode design
//               C:/Users/canpi/Documents/repositories/circuit-disguise/designs/transparent_latch/xilinx_netlist.v
// Design      : latch
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tftg256-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "778ddb74" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module latch
   (en,
    D,
    Q);
  input en;
  input D;
  output Q;

  wire D;
  wire D_IBUF;
  wire GND_1;
  wire Q;
  wire Q_OBUF;
  wire VCC_1;
  wire en;
  wire en_IBUF;
  wire en_IBUF_BUFG;

  IBUF #(
    .CCIO_EN("TRUE")) 
    D_IBUF_inst
       (.I(D),
        .O(D_IBUF));
  GND GND
       (.G(GND_1));
  OBUF Q_OBUF_inst
       (.I(Q_OBUF),
        .O(Q));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    Q_reg_reg
       (.CLR(GND_1),
        .D(D_IBUF),
        .G(en_IBUF_BUFG),
        .GE(VCC_1),
        .Q(Q_OBUF));
  VCC VCC
       (.P(VCC_1));
  BUFG en_IBUF_BUFG_inst
       (.I(en_IBUF),
        .O(en_IBUF_BUFG));
  IBUF #(
    .CCIO_EN("TRUE")) 
    en_IBUF_inst
       (.I(en),
        .O(en_IBUF));
endmodule
