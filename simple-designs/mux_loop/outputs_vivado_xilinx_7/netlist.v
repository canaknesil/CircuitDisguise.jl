// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2.2 (lin64) Build 3118627 Tue Feb  9 05:13:49 MST 2021
// Date        : Fri Aug 11 17:08:51 2023
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design
//               /home/canaknesil/Documents/repos/circuit-disguise/simple-designs/mux_loop/xilinx_netlist.v
// Design      : mux_loop
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tftg256-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "56b7ee42" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module mux_loop
   (en,
    q);
  input en;
  output q;

  wire \<const0> ;
  wire en;
  wire en_IBUF;
  wire q;
  wire q_OBUF;

  GND GND
       (.G(\<const0> ));
  (* box_type = "PRIMITIVE" *) 
  MUXF8 MUXF8_inst
       (.I0(en_IBUF),
        .I1(\<const0> ),
        .O(q_OBUF),
        .S(q_OBUF));
  IBUF en_IBUF_inst
       (.I(en),
        .O(en_IBUF));
  OBUF q_OBUF_inst
       (.I(q_OBUF),
        .O(q));
endmodule
