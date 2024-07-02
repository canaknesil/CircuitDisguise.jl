// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu Mar 21 17:59:20 2024
// Host        : DESKTOP-A95ADKL running 64-bit major release  (build 9200)
// Command     : write_verilog -mode design
//               C:/Users/canpi/Documents/repositories/circuit-disguise/simple-designs/lut6x2_benign_loop/outputs_vivado_xilinx_ultrascale/netlist.v
// Design      : top
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xazu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "ff90343e" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module top
   (x,
    y);
  input x;
  output y;

  wire \<const0> ;
  (* DONT_TOUCH *) wire a;
  wire x;
  wire x_IBUF;
  wire y;
  wire y_OBUF;

  GND GND
       (.G(\<const0> ));
  (* BOX_TYPE = "PRIMITIVE" *) 
  LUT6_2 #(
    .INIT(64'hAAAAAAAAAAAAAAAA)) 
    LUT6_2_inst
       (.I0(x_IBUF),
        .I1(a),
        .I2(\<const0> ),
        .I3(\<const0> ),
        .I4(\<const0> ),
        .I5(\<const0> ),
        .O5(y_OBUF),
        .O6(a));
  IBUF #(
    .CCIO_EN("TRUE")) 
    x_IBUF_inst
       (.I(x),
        .O(x_IBUF));
  OBUF y_OBUF_inst
       (.I(y_OBUF),
        .O(y));
endmodule
