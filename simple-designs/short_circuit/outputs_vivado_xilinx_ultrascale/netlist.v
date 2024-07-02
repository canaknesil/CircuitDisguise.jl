// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Fri Mar 15 11:38:24 2024
// Host        : canaknesil-dell running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -mode design
//               /home/canaknesil/Documents/repos/circuit-disguise/simple-designs/short_circuit/outputs_vivado_xilinx_ultrascale/netlist.v
// Design      : top
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xazu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module top
   (a,
    b,
    c);
  input a;
  input b;
  output c;

  wire a;
  wire b;
  wire c;
  wire c_OBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(c_OBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(c_OBUF));
  OBUF c_OBUF_inst
       (.I(c_OBUF),
        .O(c));
endmodule
