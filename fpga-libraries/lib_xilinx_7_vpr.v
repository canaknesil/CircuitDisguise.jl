// This library merges cell from 3 different files:

// 1) F4PGA installation:
// /f4pga/xc7/conda/envs/xc7/share/yosys/quicklogic/qlf_k6n10f/primitives_sim.v

// 2) F4PGA installation:
// f4pga/xc7/share/f4pga/techmaps/xc7_vpr/techmap/cells_sim.v

// 3) Yosys source code:
// yosys/techlibs/xilinx/cells_sim.v


// Modules below are from Yosys source code:
// yosys/techlibs/xilinx/cells_sim.v


/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

// See Xilinx UG953 and UG474 for a description of the cell types below.
// http://www.xilinx.com/support/documentation/user_guides/ug474_7Series_CLB.pdf
// http://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_4/ug953-vivado-7series-libraries.pdf

module VCC(output VCC);
  assign VCC = 1;
endmodule

module GND(output GND);
  assign GND = 0;
endmodule

module IBUF(
    output O,
    (* iopad_external_pin *)
    input I);
  parameter CCIO_EN = "TRUE";
  parameter CAPACITANCE = "DONT_CARE";
  parameter IBUF_DELAY_VALUE = "0";
  parameter IBUF_LOW_PWR = "TRUE";
  parameter IFD_DELAY_VALUE = "AUTO";
  parameter IOSTANDARD = "DEFAULT";
  assign O = I;
  specify
    (I => O) = 0;
  endspecify
endmodule

module IBUFG(
    output O,
    (* iopad_external_pin *)
    input I);
  parameter CAPACITANCE = "DONT_CARE";
  parameter IBUF_DELAY_VALUE = "0";
  parameter IBUF_LOW_PWR = "TRUE";
  parameter IOSTANDARD = "DEFAULT";
  assign O = I;
endmodule

module OBUF(
    (* iopad_external_pin *)
    output O,
    input I);
  parameter CAPACITANCE = "DONT_CARE";
  parameter IOSTANDARD = "DEFAULT";
  parameter DRIVE = 12;
  parameter SLEW = "SLOW";
  assign O = I;
  specify
    (I => O) = 0;
  endspecify
endmodule

module IOBUF (
    (* iopad_external_pin *)
    inout IO,
    output O,
    input I,
    input T
);
    parameter integer DRIVE = 12;
    parameter IBUF_LOW_PWR = "TRUE";
    parameter IOSTANDARD = "DEFAULT";
    parameter SLEW = "SLOW";
    assign IO = T ? 1'bz : I;
    assign O = IO;
    specify
        (I => IO) = 0;
        (IO => O) = 0;
    endspecify
endmodule

module OBUFT (
    (* iopad_external_pin *)
    output O,
    input I,
    input T
);
    parameter CAPACITANCE = "DONT_CARE";
    parameter integer DRIVE = 12;
    parameter IOSTANDARD = "DEFAULT";
    parameter SLEW = "SLOW";
    assign O = T ? 1'bz : I;
    specify
        (I => O) = 0;
    endspecify
endmodule

module BUFG(
    (* clkbuf_driver *)
    output O,
    input I);
  assign O = I;
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/CLK_BUFG_TOP_R.sdf#L11
    (I => O) = 96;
  endspecify
endmodule

module BUFGCTRL(
    (* clkbuf_driver *)
    output O,
    input I0, input I1,
    (* invertible_pin = "IS_S0_INVERTED" *)
    input S0,
    (* invertible_pin = "IS_S1_INVERTED" *)
    input S1,
    (* invertible_pin = "IS_CE0_INVERTED" *)
    input CE0,
    (* invertible_pin = "IS_CE1_INVERTED" *)
    input CE1,
    (* invertible_pin = "IS_IGNORE0_INVERTED" *)
    input IGNORE0,
    (* invertible_pin = "IS_IGNORE1_INVERTED" *)
    input IGNORE1);

parameter [0:0] INIT_OUT = 1'b0;
parameter PRESELECT_I0 = "FALSE";
parameter PRESELECT_I1 = "FALSE";
parameter [0:0] IS_CE0_INVERTED = 1'b0;
parameter [0:0] IS_CE1_INVERTED = 1'b0;
parameter [0:0] IS_S0_INVERTED = 1'b0;
parameter [0:0] IS_S1_INVERTED = 1'b0;
parameter [0:0] IS_IGNORE0_INVERTED = 1'b0;
parameter [0:0] IS_IGNORE1_INVERTED = 1'b0;

wire I0_internal = ((CE0 ^ IS_CE0_INVERTED) ? I0 : INIT_OUT);
wire I1_internal = ((CE1 ^ IS_CE1_INVERTED) ? I1 : INIT_OUT);
wire S0_true = (S0 ^ IS_S0_INVERTED);
wire S1_true = (S1 ^ IS_S1_INVERTED);

assign O = S0_true ? I0_internal : (S1_true ? I1_internal : INIT_OUT);

endmodule

module BUFHCE(
    (* clkbuf_driver *)
    output O,
    input I,
    (* invertible_pin = "IS_CE_INVERTED" *)
    input CE);

parameter [0:0] INIT_OUT = 1'b0;
parameter CE_TYPE = "SYNC";
parameter [0:0] IS_CE_INVERTED = 1'b0;

assign O = ((CE ^ IS_CE_INVERTED) ? I : INIT_OUT);

endmodule

// module OBUFT(output O, input I, T);
//   assign O = T ? 1'bz : I;
// endmodule

// module IOBUF(inout IO, output O, input I, T);
//   assign O = IO, IO = T ? 1'bz : I;
// endmodule

module INV(
    (* clkbuf_inv = "I" *)
    output O,
    input I
);
  assign O = !I;
  specify
    (I => O) = 127;
  endspecify
endmodule

(* abc9_lut=1 *)
module LUT1(output O, input I0);
  parameter [1:0] INIT = 0;
  assign O = I0 ? INIT[1] : INIT[0];
  specify
    (I0 => O) = 127;
  endspecify
endmodule

(* abc9_lut=2 *)
module LUT2(output O, input I0, I1);
  parameter [3:0] INIT = 0;
  wire [ 1: 0] s1 = I1 ? INIT[ 3: 2] : INIT[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 238;
    (I1 => O) = 127;
  endspecify
endmodule

(* abc9_lut=3 *)
module LUT3(output O, input I0, I1, I2);
  parameter [7:0] INIT = 0;
  wire [ 3: 0] s2 = I2 ? INIT[ 7: 4] : INIT[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 407;
    (I1 => O) = 238;
    (I2 => O) = 127;
  endspecify
endmodule

(* abc9_lut=3 *)
module LUT4(output O, input I0, I1, I2, I3);
  parameter [15:0] INIT = 0;
  wire [ 7: 0] s3 = I3 ? INIT[15: 8] : INIT[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 472;
    (I1 => O) = 407;
    (I2 => O) = 238;
    (I3 => O) = 127;
  endspecify
endmodule

(* abc9_lut=3 *)
module LUT5(output O, input I0, I1, I2, I3, I4);
  parameter [31:0] INIT = 0;
  wire [15: 0] s4 = I4 ? INIT[31:16] : INIT[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 631;
    (I1 => O) = 472;
    (I2 => O) = 407;
    (I3 => O) = 238;
    (I4 => O) = 127;
  endspecify
endmodule

// This is a placeholder for ABC9 to extract the area/delay
//   cost of 3-input LUTs and is not intended to be instantiated

(* abc9_lut=5 *)
module LUT6(output O, input I0, I1, I2, I3, I4, I5);
  parameter [63:0] INIT = 0;
  wire [31: 0] s5 = I5 ? INIT[63:32] : INIT[31: 0];
  wire [15: 0] s4 = I4 ?   s5[31:16] :   s5[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
  specify
    (I0 => O) = 642;
    (I1 => O) = 631;
    (I2 => O) = 472;
    (I3 => O) = 407;
    (I4 => O) = 238;
    (I5 => O) = 127;
  endspecify
endmodule

module LUT6_2(output O6, output O5, input I0, I1, I2, I3, I4, I5);
  parameter [63:0] INIT = 0;
  wire [31: 0] s5 = I5 ? INIT[63:32] : INIT[31: 0];
  wire [15: 0] s4 = I4 ?   s5[31:16] :   s5[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O6 = I0 ? s1[1] : s1[0];

  wire [15: 0] s5_4 = I4 ? INIT[31:16] : INIT[15: 0];
  wire [ 7: 0] s5_3 = I3 ? s5_4[15: 8] : s5_4[ 7: 0];
  wire [ 3: 0] s5_2 = I2 ? s5_3[ 7: 4] : s5_3[ 3: 0];
  wire [ 1: 0] s5_1 = I1 ? s5_2[ 3: 2] : s5_2[ 1: 0];
  assign O5 = I0 ? s5_1[1] : s5_1[0];
endmodule

// This is a placeholder for ABC9 to extract the area/delay
//   cost of 3-input LUTs and is not intended to be instantiated
(* abc9_lut=10 *)
module \$__ABC9_LUT7 (output O, input I0, I1, I2, I3, I4, I5, I6);
`ifndef __ICARUS__
  specify
                                                 // https://github.com/SymbiFlow/prjxray-db/blob/1c85daf1b115da4d27ca83c6b89f53a94de39748/artix7/timings/slicel.sdf#L867
    (I0 => O) = 642 + 223 /* to cross F7BMUX */ + 174 /* CMUX */;
    (I1 => O) = 631 + 223 /* to cross F7BMUX */ + 174 /* CMUX */;
    (I2 => O) = 472 + 223 /* to cross F7BMUX */ + 174 /* CMUX */;
    (I3 => O) = 407 + 223 /* to cross F7BMUX */ + 174 /* CMUX */;
    (I4 => O) = 238 + 223 /* to cross F7BMUX */ + 174 /* CMUX */;
    (I5 => O) = 127 + 223 /* to cross F7BMUX */ + 174 /* CMUX */;
    (I6 => O) = 0 + 296 /* to select F7BMUX */ + 174 /* CMUX */;
  endspecify
`endif
endmodule

// This is a placeholder for ABC9 to extract the area/delay
//   cost of 3-input LUTs and is not intended to be instantiated
(* abc9_lut=20 *)
module \$__ABC9_LUT8 (output O, input I0, I1, I2, I3, I4, I5, I6, I7);
`ifndef __ICARUS__
  specify
                                                                             // https://github.com/SymbiFlow/prjxray-db/blob/1c85daf1b115da4d27ca83c6b89f53a94de39748/artix7/timings/slicel.sdf#L716
    (I0 => O) = 642 + 223 /* to cross F7BMUX */ + 104 /* to cross F8MUX */ + 192 /* BMUX */;
    (I1 => O) = 631 + 223 /* to cross F7BMUX */ + 104 /* to cross F8MUX */ + 192 /* BMUX */;
    (I2 => O) = 472 + 223 /* to cross F7BMUX */ + 104 /* to cross F8MUX */ + 192 /* BMUX */;
    (I3 => O) = 407 + 223 /* to cross F7BMUX */ + 104 /* to cross F8MUX */ + 192 /* BMUX */;
    (I4 => O) = 238 + 223 /* to cross F7BMUX */ + 104 /* to cross F8MUX */ + 192 /* BMUX */;
    (I5 => O) = 127 + 223 /* to cross F7BMUX */ + 104 /* to cross F8MUX */ + 192 /* BMUX */;
    (I6 => O) = 0 + 296 /* to select F7BMUX */  + 104 /* to cross F8MUX */ + 192 /* BMUX */;
    (I7 => O) = 0 + 0 + 273 /* to select F8MUX */ + 192 /* BMUX */;
  endspecify
`endif
endmodule

module MUXCY(output O, input CI, DI, S);
  assign O = S ? CI : DI;
endmodule

module MUXF5(output O, input I0, I1, S);
  assign O = S ? I1 : I0;
endmodule

module MUXF6(output O, input I0, I1, S);
  assign O = S ? I1 : I0;
endmodule

(* abc9_box, lib_whitebox *)
module MUXF7(output O, input I0, I1, S);
  assign O = S ? I1 : I0;
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L451-L453
    (I0 => O) = 217;
    (I1 => O) = 223;
    (S => O) = 296;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module MUXF8(output O, input I0, I1, S);
  assign O = S ? I1 : I0;
  specify
    // Max delays from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L462-L464
    (I0 => O) = 104;
    (I1 => O) = 94;
    (S => O) = 273;
  endspecify
endmodule

module MUXF9(output O, input I0, I1, S);
  assign O = S ? I1 : I0;
endmodule

module XORCY(output O, input CI, LI);
  assign O = CI ^ LI;
endmodule

(* abc9_box, lib_whitebox *)
module CARRY4(
  (* abc9_carry *)
  output [3:0] CO,
  output [3:0] O,
  (* abc9_carry *)
  input        CI,
  input        CYINIT,
  input  [3:0] DI, S
);
  assign O = S ^ {CO[2:0], CI | CYINIT};
  assign CO[0] = S[0] ? CI | CYINIT : DI[0];
  assign CO[1] = S[1] ? CO[0] : DI[1];
  assign CO[2] = S[2] ? CO[1] : DI[2];
  assign CO[3] = S[3] ? CO[2] : DI[3];
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L11-L46
    (CYINIT => O[0]) = 482;
    (S[0]   => O[0]) = 223;
    (CI     => O[0]) = 222;
    (CYINIT => O[1]) = 598;
    (DI[0]  => O[1]) = 407;
    (S[0]   => O[1]) = 400;
    (S[1]   => O[1]) = 205;
    (CI     => O[1]) = 334;
    (CYINIT => O[2]) = 584;
    (DI[0]  => O[2]) = 556;
    (DI[1]  => O[2]) = 537;
    (S[0]   => O[2]) = 523;
    (S[1]   => O[2]) = 558;
    (S[2]   => O[2]) = 226;
    (CI     => O[2]) = 239;
    (CYINIT => O[3]) = 642;
    (DI[0]  => O[3]) = 615;
    (DI[1]  => O[3]) = 596;
    (DI[2]  => O[3]) = 438;
    (S[0]   => O[3]) = 582;
    (S[1]   => O[3]) = 618;
    (S[2]   => O[3]) = 330;
    (S[3]   => O[3]) = 227;
    (CI     => O[3]) = 313;
    (CYINIT => CO[0]) = 536;
    (DI[0]  => CO[0]) = 379;
    (S[0]   => CO[0]) = 340;
    (CI     => CO[0]) = 271;
    (CYINIT => CO[1]) = 494;
    (DI[0]  => CO[1]) = 465;
    (DI[1]  => CO[1]) = 445;
    (S[0]   => CO[1]) = 433;
    (S[1]   => CO[1]) = 469;
    (CI     => CO[1]) = 157;
    (CYINIT => CO[2]) = 592;
    (DI[0]  => CO[2]) = 540;
    (DI[1]  => CO[2]) = 520;
    (DI[2]  => CO[2]) = 356;
    (S[0]   => CO[2]) = 512;
    (S[1]   => CO[2]) = 548;
    (S[2]   => CO[2]) = 292;
    (CI     => CO[2]) = 228;
    (CYINIT => CO[3]) = 580;
    (DI[0]  => CO[3]) = 526;
    (DI[1]  => CO[3]) = 507;
    (DI[2]  => CO[3]) = 398;
    (DI[3]  => CO[3]) = 385;
    (S[0]   => CO[3]) = 508;
    (S[1]   => CO[3]) = 528;
    (S[2]   => CO[3]) = 378;
    (S[3]   => CO[3]) = 380;
    (CI     => CO[3]) = 114;
  endspecify
endmodule

module CARRY8(
  output [7:0] CO,
  output [7:0] O,
  input        CI,
  input        CI_TOP,
  input  [7:0] DI, S
);
  parameter CARRY_TYPE = "SINGLE_CY8";
  wire CI4 = (CARRY_TYPE == "DUAL_CY4" ? CI_TOP : CO[3]);
  assign O = S ^ {CO[6:4], CI4, CO[2:0], CI};
  assign CO[0] = S[0] ? CI : DI[0];
  assign CO[1] = S[1] ? CO[0] : DI[1];
  assign CO[2] = S[2] ? CO[1] : DI[2];
  assign CO[3] = S[3] ? CO[2] : DI[3];
  assign CO[4] = S[4] ? CI4 : DI[4];
  assign CO[5] = S[5] ? CO[4] : DI[5];
  assign CO[6] = S[6] ? CO[5] : DI[6];
  assign CO[7] = S[7] ? CO[6] : DI[7];
endmodule

module ORCY (output O, input CI, I);
  assign O = CI | I;
endmodule

module MULT_AND (output LO, input I0, I1);
  assign LO = I0 & I1;
endmodule

// Flip-flops and latches.

// Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L238-L250

(* abc9_flop, lib_whitebox *)
module FDRE (
  output reg Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  input CE,
  (* invertible_pin = "IS_D_INVERTED" *)
  input D,
  (* invertible_pin = "IS_R_INVERTED" *)
  input R
);
  parameter [0:0] INIT = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_D_INVERTED = 1'b0;
  parameter [0:0] IS_R_INVERTED = 1'b0;
  initial Q <= INIT;
  generate
  case (|IS_C_INVERTED)
    1'b0: always @(posedge C) if (R == !IS_R_INVERTED) Q <= 1'b0; else if (CE) Q <= D ^ IS_D_INVERTED;
    1'b1: always @(negedge C) if (R == !IS_R_INVERTED) Q <= 1'b0; else if (CE) Q <= D ^ IS_D_INVERTED;
  endcase
  endgenerate
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , posedge C &&& CE && !IS_C_INVERTED , /*-46*/ 0); // Negative times not currently supported
    $setup(D , negedge C &&& CE &&  IS_C_INVERTED , /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE, posedge C &&& !IS_C_INVERTED, 109);
    $setup(CE, negedge C &&&  IS_C_INVERTED, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(R , posedge C &&& !IS_C_INVERTED, 404);
    $setup(R , negedge C &&&  IS_C_INVERTED, 404);
    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L243
    if (!IS_C_INVERTED && R != IS_R_INVERTED)        (posedge C => (Q : 1'b0)) = 303;
    if ( IS_C_INVERTED && R != IS_R_INVERTED)        (negedge C => (Q : 1'b0)) = 303;
    if (!IS_C_INVERTED && R == IS_R_INVERTED && CE) (posedge C => (Q : D ^ IS_D_INVERTED)) = 303;
    if ( IS_C_INVERTED && R == IS_R_INVERTED && CE) (negedge C => (Q : D ^ IS_D_INVERTED)) = 303;
  endspecify
endmodule

(* abc9_flop, lib_whitebox *)
module FDRE_1 (
  output reg Q,
  (* clkbuf_sink *)
  input C,
  input CE,
  input D,
  input R
);
  parameter [0:0] INIT = 1'b0;
  initial Q <= INIT;
  always @(negedge C) if (R) Q <= 1'b0; else if (CE) Q <= D;
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , negedge C &&& CE, /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE, negedge C, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(R , negedge C, 404);    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L243
    if (R)        (negedge C => (Q : 1'b0)) = 303;
    if (!R && CE) (negedge C => (Q : D)) = 303;
  endspecify
endmodule

(* abc9_flop, lib_whitebox *)
module FDSE (
  output reg Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  input CE,
  (* invertible_pin = "IS_D_INVERTED" *)
  input D,
  (* invertible_pin = "IS_S_INVERTED" *)
  input S
);
  parameter [0:0] INIT = 1'b1;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_D_INVERTED = 1'b0;
  parameter [0:0] IS_S_INVERTED = 1'b0;
  initial Q <= INIT;
  generate
  case (|IS_C_INVERTED)
    1'b0: always @(posedge C) if (S == !IS_S_INVERTED) Q <= 1'b1; else if (CE) Q <= D ^ IS_D_INVERTED;
    1'b1: always @(negedge C) if (S == !IS_S_INVERTED) Q <= 1'b1; else if (CE) Q <= D ^ IS_D_INVERTED;
  endcase
  endgenerate
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , posedge C &&& !IS_C_INVERTED && CE, /*-46*/ 0); // Negative times not currently supported
    $setup(D , negedge C &&&  IS_C_INVERTED && CE, /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE, posedge C &&& !IS_C_INVERTED, 109);
    $setup(CE, negedge C &&&  IS_C_INVERTED, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(S , posedge C &&& !IS_C_INVERTED, 404);
    $setup(S , negedge C &&&  IS_C_INVERTED, 404);
    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L243
    if (!IS_C_INVERTED && S != IS_S_INVERTED)       (posedge C => (Q : 1'b1)) = 303;
    if ( IS_C_INVERTED && S != IS_S_INVERTED)       (negedge C => (Q : 1'b1)) = 303;
    if (!IS_C_INVERTED && S == IS_S_INVERTED && CE) (posedge C => (Q : D ^ IS_D_INVERTED)) = 303;
    if ( IS_C_INVERTED && S == IS_S_INVERTED && CE) (negedge C => (Q : D ^ IS_D_INVERTED)) = 303;
  endspecify
endmodule

(* abc9_flop, lib_whitebox *)
module FDSE_1 (
  output reg Q,
  (* clkbuf_sink *)
  input C,
  input CE,
  input D,
  input S
);
  parameter [0:0] INIT = 1'b1;
  initial Q <= INIT;
  always @(negedge C) if (S) Q <= 1'b1; else if (CE) Q <= D;
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , negedge C &&& CE, /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE, negedge C, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(S , negedge C, 404);
    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L243
    if (S)        (negedge C => (Q : 1'b1)) = 303;
    if (!S && CE) (negedge C => (Q : D)) = 303;
  endspecify
endmodule

module FDRSE (
  output reg Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  (* invertible_pin = "IS_CE_INVERTED" *)
  input CE,
  (* invertible_pin = "IS_D_INVERTED" *)
  input D,
  (* invertible_pin = "IS_R_INVERTED" *)
  input R,
  (* invertible_pin = "IS_S_INVERTED" *)
  input S
);
  parameter [0:0] INIT = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_CE_INVERTED = 1'b0;
  parameter [0:0] IS_D_INVERTED = 1'b0;
  parameter [0:0] IS_R_INVERTED = 1'b0;
  parameter [0:0] IS_S_INVERTED = 1'b0;
  initial Q <= INIT;
  wire c = C ^ IS_C_INVERTED;
  wire ce = CE ^ IS_CE_INVERTED;
  wire d = D ^ IS_D_INVERTED;
  wire r = R ^ IS_R_INVERTED;
  wire s = S ^ IS_S_INVERTED;
  always @(posedge c)
    if (r)
      Q <= 0;
    else if (s)
      Q <= 1;
    else if (ce)
      Q <= d;
endmodule

module FDRSE_1 (
  output reg Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  (* invertible_pin = "IS_CE_INVERTED" *)
  input CE,
  (* invertible_pin = "IS_D_INVERTED" *)
  input D,
  (* invertible_pin = "IS_R_INVERTED" *)
  input R,
  (* invertible_pin = "IS_S_INVERTED" *)
  input S
);
  parameter [0:0] INIT = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_CE_INVERTED = 1'b0;
  parameter [0:0] IS_D_INVERTED = 1'b0;
  parameter [0:0] IS_R_INVERTED = 1'b0;
  parameter [0:0] IS_S_INVERTED = 1'b0;
  initial Q <= INIT;
  wire c = C ^ IS_C_INVERTED;
  wire ce = CE ^ IS_CE_INVERTED;
  wire d = D ^ IS_D_INVERTED;
  wire r = R ^ IS_R_INVERTED;
  wire s = S ^ IS_S_INVERTED;
  always @(negedge c)
    if (r)
      Q <= 0;
    else if (s)
      Q <= 1;
    else if (ce)
      Q <= d;
endmodule

(* abc9_box, lib_whitebox *)
module FDCE (
  output reg Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  input CE,
  (* invertible_pin = "IS_CLR_INVERTED" *)
  input CLR,
  (* invertible_pin = "IS_D_INVERTED" *)
  input D
);
  parameter [0:0] INIT = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_D_INVERTED = 1'b0;
  parameter [0:0] IS_CLR_INVERTED = 1'b0;
  initial Q <= INIT;
  generate
  case ({|IS_C_INVERTED, |IS_CLR_INVERTED})
    2'b00: always @(posedge C, posedge CLR) if ( CLR) Q <= 1'b0; else if (CE) Q <= D ^ IS_D_INVERTED;
    2'b01: always @(posedge C, negedge CLR) if (!CLR) Q <= 1'b0; else if (CE) Q <= D ^ IS_D_INVERTED;
    2'b10: always @(negedge C, posedge CLR) if ( CLR) Q <= 1'b0; else if (CE) Q <= D ^ IS_D_INVERTED;
    2'b11: always @(negedge C, negedge CLR) if (!CLR) Q <= 1'b0; else if (CE) Q <= D ^ IS_D_INVERTED;
  endcase
  endgenerate
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , posedge C &&& !IS_C_INVERTED && CE, /*-46*/ 0); // Negative times not currently supported
    $setup(D , negedge C &&&  IS_C_INVERTED && CE, /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE , posedge C &&& !IS_C_INVERTED, 109);
    $setup(CE , negedge C &&&  IS_C_INVERTED, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(CLR, posedge C &&& !IS_C_INVERTED, 404);
    $setup(CLR, negedge C &&&  IS_C_INVERTED, 404);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L270
`ifndef YOSYS
    if (!IS_CLR_INVERTED) (posedge CLR => (Q : 1'b0)) = 764;
    if ( IS_CLR_INVERTED) (negedge CLR => (Q : 1'b0)) = 764;
`else
    if (IS_CLR_INVERTED != CLR) (CLR => Q) = 764; // Technically, this should be an edge sensitive path
                                                  // but for facilitating a bypass box, let's pretend it's
                                                  // a simple path
`endif
    if (!IS_C_INVERTED && CLR == IS_CLR_INVERTED && CE) (posedge C => (Q : D ^ IS_D_INVERTED)) = 303;
    if ( IS_C_INVERTED && CLR == IS_CLR_INVERTED && CE) (negedge C => (Q : D ^ IS_D_INVERTED)) = 303;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module FDCE_1 (
  output reg Q,
  (* clkbuf_sink *)
  input C,
  input CE,
  input CLR,
  input D
);
  parameter [0:0] INIT = 1'b0;
  initial Q <= INIT;
  always @(negedge C, posedge CLR) if (CLR) Q <= 1'b0; else if (CE) Q <= D;
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , negedge C &&& CE, /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE , negedge C, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(CLR, negedge C, 404);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L270
`ifndef YOSYS
    (posedge CLR => (Q : 1'b0)) = 764;
`else
    if (CLR) (CLR => Q) = 764; // Technically, this should be an edge sensitive path
                               // but for facilitating a bypass box, let's pretend it's
                               // a simple path
`endif
    if (!CLR && CE) (negedge C => (Q : D)) = 303;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module FDPE (
  output reg Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  input CE,
  (* invertible_pin = "IS_D_INVERTED" *)
  input D,
  (* invertible_pin = "IS_PRE_INVERTED" *)
  input PRE
);
  parameter [0:0] INIT = 1'b1;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_D_INVERTED = 1'b0;
  parameter [0:0] IS_PRE_INVERTED = 1'b0;
  initial Q <= INIT;
  generate case ({|IS_C_INVERTED, |IS_PRE_INVERTED})
    2'b00: always @(posedge C, posedge PRE) if ( PRE) Q <= 1'b1; else if (CE) Q <= D ^ IS_D_INVERTED;
    2'b01: always @(posedge C, negedge PRE) if (!PRE) Q <= 1'b1; else if (CE) Q <= D ^ IS_D_INVERTED;
    2'b10: always @(negedge C, posedge PRE) if ( PRE) Q <= 1'b1; else if (CE) Q <= D ^ IS_D_INVERTED;
    2'b11: always @(negedge C, negedge PRE) if (!PRE) Q <= 1'b1; else if (CE) Q <= D ^ IS_D_INVERTED;
  endcase
  endgenerate
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , posedge C &&& !IS_C_INVERTED && CE, /*-46*/ 0); // Negative times not currently supported
    $setup(D , negedge C &&&  IS_C_INVERTED && CE, /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE , posedge C &&& !IS_C_INVERTED, 109);
    $setup(CE , negedge C &&&  IS_C_INVERTED, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(PRE, posedge C &&& !IS_C_INVERTED, 404);
    $setup(PRE, negedge C &&&  IS_C_INVERTED, 404);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L270
`ifndef YOSYS
    if (!IS_PRE_INVERTED) (posedge PRE => (Q : 1'b1)) = 764;
    if ( IS_PRE_INVERTED) (negedge PRE => (Q : 1'b1)) = 764;
`else
    if (IS_PRE_INVERTED != PRE) (PRE => Q) = 764; // Technically, this should be an edge sensitive path
                                                  // but for facilitating a bypass box, let's pretend it's
                                                  // a simple path
`endif
    if (!IS_C_INVERTED && PRE == IS_PRE_INVERTED && CE) (posedge C => (Q : D ^ IS_D_INVERTED)) = 303;
    if ( IS_C_INVERTED && PRE == IS_PRE_INVERTED && CE) (negedge C => (Q : D ^ IS_D_INVERTED)) = 303;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module FDPE_1 (
  output reg Q,
  (* clkbuf_sink *)
  input C,
  input CE,
  input D,
  input PRE
);
  parameter [0:0] INIT = 1'b1;
  initial Q <= INIT;
  always @(negedge C, posedge PRE) if (PRE) Q <= 1'b1; else if (CE) Q <= D;
  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L249
    $setup(D , negedge C &&& CE, /*-46*/ 0); // Negative times not currently supported
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE , negedge C, 109);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L274
    $setup(PRE, negedge C, 404);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L270
`ifndef YOSYS
    (posedge PRE => (Q : 1'b1)) = 764;
`else
    if (PRE) (PRE => Q) = 764; // Technically, this should be an edge sensitive path
                               // but for facilitating a bypass box, let's pretend it's
                               // a simple path
`endif
    if (!PRE && CE) (negedge C => (Q : D)) = 303;
  endspecify
endmodule

module FDCPE (
  output wire Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  input CE,
  (* invertible_pin = "IS_CLR_INVERTED" *)
  input CLR,
  input D,
  (* invertible_pin = "IS_PRE_INVERTED" *)
  input PRE
);
  parameter [0:0] INIT = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_CLR_INVERTED = 1'b0;
  parameter [0:0] IS_PRE_INVERTED = 1'b0;
  wire c = C ^ IS_C_INVERTED;
  wire clr = CLR ^ IS_CLR_INVERTED;
  wire pre = PRE ^ IS_PRE_INVERTED;
  // Hacky model to avoid simulation-synthesis mismatches.
  reg qc, qp, qs;
  initial qc = INIT;
  initial qp = INIT;
  initial qs = 0;
  always @(posedge c, posedge clr) begin
    if (clr)
      qc <= 0;
    else if (CE)
      qc <= D;
  end
  always @(posedge c, posedge pre) begin
    if (pre)
      qp <= 1;
    else if (CE)
      qp <= D;
  end
  always @* begin
    if (clr)
      qs <= 0;
    else if (pre)
      qs <= 1;
  end
  assign Q = qs ? qp : qc;
endmodule

module FDCPE_1 (
  output wire Q,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_C_INVERTED" *)
  input C,
  input CE,
  (* invertible_pin = "IS_CLR_INVERTED" *)
  input CLR,
  input D,
  (* invertible_pin = "IS_PRE_INVERTED" *)
  input PRE
);
  parameter [0:0] INIT = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  parameter [0:0] IS_CLR_INVERTED = 1'b0;
  parameter [0:0] IS_PRE_INVERTED = 1'b0;
  wire c = C ^ IS_C_INVERTED;
  wire clr = CLR ^ IS_CLR_INVERTED;
  wire pre = PRE ^ IS_PRE_INVERTED;
  // Hacky model to avoid simulation-synthesis mismatches.
  reg qc, qp, qs;
  initial qc = INIT;
  initial qp = INIT;
  initial qs = 0;
  always @(negedge c, posedge clr) begin
    if (clr)
      qc <= 0;
    else if (CE)
      qc <= D;
  end
  always @(negedge c, posedge pre) begin
    if (pre)
      qp <= 1;
    else if (CE)
      qp <= D;
  end
  always @* begin
    if (clr)
      qs <= 0;
    else if (pre)
      qs <= 1;
  end
  assign Q = qs ? qp : qc;
endmodule

module LDCE (
  output reg Q,
  (* invertible_pin = "IS_CLR_INVERTED" *)
  input CLR,
  input D,
  (* invertible_pin = "IS_G_INVERTED" *)
  input G,
  input GE
);
  parameter [0:0] INIT = 1'b0;
  parameter [0:0] IS_CLR_INVERTED = 1'b0;
  parameter [0:0] IS_G_INVERTED = 1'b0;
  parameter MSGON = "TRUE";
  parameter XON = "TRUE";
  initial Q = INIT;
  wire clr = CLR ^ IS_CLR_INVERTED;
  wire g = G ^ IS_G_INVERTED;
  always @*
    if (clr) Q <= 1'b0;
    else if (GE && g) Q <= D;
endmodule

module LDPE (
  output reg Q,
  input D,
  (* invertible_pin = "IS_G_INVERTED" *)
  input G,
  input GE,
  (* invertible_pin = "IS_PRE_INVERTED" *)
  input PRE
);
  parameter [0:0] INIT = 1'b1;
  parameter [0:0] IS_G_INVERTED = 1'b0;
  parameter [0:0] IS_PRE_INVERTED = 1'b0;
  parameter MSGON = "TRUE";
  parameter XON = "TRUE";
  initial Q = INIT;
  wire g = G ^ IS_G_INVERTED;
  wire pre = PRE ^ IS_PRE_INVERTED;
  always @*
    if (pre) Q <= 1'b1;
    else if (GE && g) Q <= D;
endmodule

module LDCPE (
  output reg Q,
  (* invertible_pin = "IS_CLR_INVERTED" *)
  input CLR,
  (* invertible_pin = "IS_D_INVERTED" *)
  input D,
  (* invertible_pin = "IS_G_INVERTED" *)
  input G,
  (* invertible_pin = "IS_GE_INVERTED" *)
  input GE,
  (* invertible_pin = "IS_PRE_INVERTED" *)
  input PRE
);
  parameter [0:0] INIT = 1'b1;
  parameter [0:0] IS_CLR_INVERTED = 1'b0;
  parameter [0:0] IS_D_INVERTED = 1'b0;
  parameter [0:0] IS_G_INVERTED = 1'b0;
  parameter [0:0] IS_GE_INVERTED = 1'b0;
  parameter [0:0] IS_PRE_INVERTED = 1'b0;
  initial Q = INIT;
  wire d = D ^ IS_D_INVERTED;
  wire g = G ^ IS_G_INVERTED;
  wire ge = GE ^ IS_GE_INVERTED;
  wire clr = CLR ^ IS_CLR_INVERTED;
  wire pre = PRE ^ IS_PRE_INVERTED;
  always @*
    if (clr) Q <= 1'b0;
    else if (pre) Q <= 1'b1;
    else if (ge && g) Q <= d;
endmodule

module AND2B1L (
  output O,
  input DI,
  (* invertible_pin = "IS_SRI_INVERTED" *)
  input SRI
);
  parameter [0:0] IS_SRI_INVERTED = 1'b0;
  assign O = DI & ~(SRI ^ IS_SRI_INVERTED);
endmodule

module OR2L (
  output O,
  input DI,
  (* invertible_pin = "IS_SRI_INVERTED" *)
  input SRI
);
  parameter [0:0] IS_SRI_INVERTED = 1'b0;
  assign O = DI | (SRI ^ IS_SRI_INVERTED);
endmodule

// LUTRAM.

// Single port.

module RAM16X1S (
  output O,
  input A0, A1, A2, A3,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [15:0] INIT = 16'h0000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  reg [15:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule

module RAM16X1S_1 (
  output O,
  input A0, A1, A2, A3,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [15:0] INIT = 16'h0000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  reg [15:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
endmodule

module RAM32X1S (
  output O,
  input A0, A1, A2, A3, A4,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [31:0] INIT = 32'h00000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  reg [31:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule

module RAM32X1S_1 (
  output O,
  input A0, A1, A2, A3, A4,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [31:0] INIT = 32'h00000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  reg [31:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
endmodule

module RAM64X1S (
  output O,
  input A0, A1, A2, A3, A4, A5,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [63:0] INIT = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [5:0] a = {A5, A4, A3, A2, A1, A0};
  reg [63:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule

module RAM64X1S_1 (
  output O,
  input A0, A1, A2, A3, A4, A5,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [63:0] INIT = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [5:0] a = {A5, A4, A3, A2, A1, A0};
  reg [63:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
endmodule

module RAM128X1S (
  output O,
  input A0, A1, A2, A3, A4, A5, A6,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [127:0] INIT = 128'h00000000000000000000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [6:0] a = {A6, A5, A4, A3, A2, A1, A0};
  reg [127:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule

module RAM128X1S_1 (
  output O,
  input A0, A1, A2, A3, A4, A5, A6,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [127:0] INIT = 128'h00000000000000000000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [6:0] a = {A6, A5, A4, A3, A2, A1, A0};
  reg [127:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
endmodule

module RAM256X1S (
  output O,
  input [7:0] A,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [255:0] INIT = 256'h0;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [255:0] mem = INIT;
  assign O = mem[A];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[A] <= D;
endmodule

module RAM512X1S (
  output O,
  input [8:0] A,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [511:0] INIT = 512'h0;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [511:0] mem = INIT;
  assign O = mem[A];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[A] <= D;
endmodule

// Single port, wide.

module RAM16X2S (
  output O0, O1,
  input A0, A1, A2, A3,
  input D0, D1,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [15:0] INIT_00 = 16'h0000;
  parameter [15:0] INIT_01 = 16'h0000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [15:0] mem0 = INIT_00;
  reg [15:0] mem1 = INIT_01;
  assign O0 = mem0[a];
  assign O1 = mem1[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D0;
      mem1[a] <= D1;
    end
endmodule

module RAM32X2S (
  output O0, O1,
  input A0, A1, A2, A3, A4,
  input D0, D1,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [31:0] INIT_00 = 32'h00000000;
  parameter [31:0] INIT_01 = 32'h00000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [31:0] mem0 = INIT_00;
  reg [31:0] mem1 = INIT_01;
  assign O0 = mem0[a];
  assign O1 = mem1[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D0;
      mem1[a] <= D1;
    end
endmodule

module RAM64X2S (
  output O0, O1,
  input A0, A1, A2, A3, A4, A5,
  input D0, D1,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [63:0] INIT_00 = 64'h0000000000000000;
  parameter [63:0] INIT_01 = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [5:0] a = {A5, A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [63:0] mem0 = INIT_00;
  reg [63:0] mem1 = INIT_01;
  assign O0 = mem0[a];
  assign O1 = mem1[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D0;
      mem1[a] <= D1;
    end
endmodule

module RAM16X4S (
  output O0, O1, O2, O3,
  input A0, A1, A2, A3,
  input D0, D1, D2, D3,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [15:0] INIT_00 = 16'h0000;
  parameter [15:0] INIT_01 = 16'h0000;
  parameter [15:0] INIT_02 = 16'h0000;
  parameter [15:0] INIT_03 = 16'h0000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [15:0] mem0 = INIT_00;
  reg [15:0] mem1 = INIT_01;
  reg [15:0] mem2 = INIT_02;
  reg [15:0] mem3 = INIT_03;
  assign O0 = mem0[a];
  assign O1 = mem1[a];
  assign O2 = mem2[a];
  assign O3 = mem3[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D0;
      mem1[a] <= D1;
      mem2[a] <= D2;
      mem3[a] <= D3;
    end
endmodule

module RAM32X4S (
  output O0, O1, O2, O3,
  input A0, A1, A2, A3, A4,
  input D0, D1, D2, D3,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [31:0] INIT_00 = 32'h00000000;
  parameter [31:0] INIT_01 = 32'h00000000;
  parameter [31:0] INIT_02 = 32'h00000000;
  parameter [31:0] INIT_03 = 32'h00000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [31:0] mem0 = INIT_00;
  reg [31:0] mem1 = INIT_01;
  reg [31:0] mem2 = INIT_02;
  reg [31:0] mem3 = INIT_03;
  assign O0 = mem0[a];
  assign O1 = mem1[a];
  assign O2 = mem2[a];
  assign O3 = mem3[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D0;
      mem1[a] <= D1;
      mem2[a] <= D2;
      mem3[a] <= D3;
    end
endmodule

module RAM16X8S (
  output [7:0] O,
  input A0, A1, A2, A3,
  input [7:0] D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [15:0] INIT_00 = 16'h0000;
  parameter [15:0] INIT_01 = 16'h0000;
  parameter [15:0] INIT_02 = 16'h0000;
  parameter [15:0] INIT_03 = 16'h0000;
  parameter [15:0] INIT_04 = 16'h0000;
  parameter [15:0] INIT_05 = 16'h0000;
  parameter [15:0] INIT_06 = 16'h0000;
  parameter [15:0] INIT_07 = 16'h0000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [15:0] mem0 = INIT_00;
  reg [15:0] mem1 = INIT_01;
  reg [15:0] mem2 = INIT_02;
  reg [15:0] mem3 = INIT_03;
  reg [15:0] mem4 = INIT_04;
  reg [15:0] mem5 = INIT_05;
  reg [15:0] mem6 = INIT_06;
  reg [15:0] mem7 = INIT_07;
  assign O[0] = mem0[a];
  assign O[1] = mem1[a];
  assign O[2] = mem2[a];
  assign O[3] = mem3[a];
  assign O[4] = mem4[a];
  assign O[5] = mem5[a];
  assign O[6] = mem6[a];
  assign O[7] = mem7[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D[0];
      mem1[a] <= D[1];
      mem2[a] <= D[2];
      mem3[a] <= D[3];
      mem4[a] <= D[4];
      mem5[a] <= D[5];
      mem6[a] <= D[6];
      mem7[a] <= D[7];
    end
endmodule

module RAM32X8S (
  output [7:0] O,
  input A0, A1, A2, A3, A4,
  input [7:0] D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [31:0] INIT_00 = 32'h00000000;
  parameter [31:0] INIT_01 = 32'h00000000;
  parameter [31:0] INIT_02 = 32'h00000000;
  parameter [31:0] INIT_03 = 32'h00000000;
  parameter [31:0] INIT_04 = 32'h00000000;
  parameter [31:0] INIT_05 = 32'h00000000;
  parameter [31:0] INIT_06 = 32'h00000000;
  parameter [31:0] INIT_07 = 32'h00000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [31:0] mem0 = INIT_00;
  reg [31:0] mem1 = INIT_01;
  reg [31:0] mem2 = INIT_02;
  reg [31:0] mem3 = INIT_03;
  reg [31:0] mem4 = INIT_04;
  reg [31:0] mem5 = INIT_05;
  reg [31:0] mem6 = INIT_06;
  reg [31:0] mem7 = INIT_07;
  assign O[0] = mem0[a];
  assign O[1] = mem1[a];
  assign O[2] = mem2[a];
  assign O[3] = mem3[a];
  assign O[4] = mem4[a];
  assign O[5] = mem5[a];
  assign O[6] = mem6[a];
  assign O[7] = mem7[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D[0];
      mem1[a] <= D[1];
      mem2[a] <= D[2];
      mem3[a] <= D[3];
      mem4[a] <= D[4];
      mem5[a] <= D[5];
      mem6[a] <= D[6];
      mem7[a] <= D[7];
    end
endmodule

// Dual port.

module RAM16X1D (
  output DPO, SPO,
  input  D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input  WCLK,
  input  WE,
  input  A0, A1, A2, A3,
  input  DPRA0, DPRA1, DPRA2, DPRA3
);
  parameter INIT = 16'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  wire [3:0] dpra = {DPRA3, DPRA2, DPRA1, DPRA0};
  reg [15:0] mem = INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule

module RAM16X1D_1 (
  output DPO, SPO,
  input  D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input  WCLK,
  input  WE,
  input  A0, A1, A2, A3,
  input  DPRA0, DPRA1, DPRA2, DPRA3
);
  parameter INIT = 16'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  wire [3:0] dpra = {DPRA3, DPRA2, DPRA1, DPRA0};
  reg [15:0] mem = INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
endmodule

(* abc9_box, lib_whitebox *)
module RAM32X1D (
  output DPO, SPO,
  input  D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input  WCLK,
  input  WE,
  input  A0, A1, A2, A3, A4,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4
);
  parameter INIT = 32'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  wire [4:0] dpra = {DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};
  reg [31:0] mem = INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986
    $setup(D , posedge WCLK &&& !IS_WCLK_INVERTED && WE, 453);
    $setup(D , negedge WCLK &&&  IS_WCLK_INVERTED && WE, 453);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L834
    $setup(WE, posedge WCLK &&& !IS_WCLK_INVERTED, 654);
    $setup(WE, negedge WCLK &&&  IS_WCLK_INVERTED, 654);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L800
    $setup(A0, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 245);
    $setup(A0, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 245);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L798
    $setup(A1, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 208);
    $setup(A1, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 208);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L796
    $setup(A2, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 147);
    $setup(A2, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 147);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L794
    $setup(A3, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 68);
    $setup(A3, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 68);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L792
    $setup(A4, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 66);
    $setup(A4, posedge WCLK &&&  IS_WCLK_INVERTED && WE, 66);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L981
    if (!IS_WCLK_INVERTED) (posedge WCLK => (SPO : D))    = 1153;
    if (!IS_WCLK_INVERTED) (posedge WCLK => (DPO : 1'bx)) = 1153;
    if ( IS_WCLK_INVERTED) (posedge WCLK => (SPO : D))    = 1153;
    if ( IS_WCLK_INVERTED) (negedge WCLK => (DPO : 1'bx)) = 1153;
    (A0 => SPO) = 642; (DPRA0 => DPO) = 642;
    (A1 => SPO) = 632; (DPRA1 => DPO) = 631;
    (A2 => SPO) = 472; (DPRA2 => DPO) = 472;
    (A3 => SPO) = 407; (DPRA3 => DPO) = 407;
    (A4 => SPO) = 238; (DPRA4 => DPO) = 238;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module RAM32X1D_1 (
  output DPO, SPO,
  input  D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input  WCLK,
  input  WE,
  input  A0,
  input  A1,
  input  A2,
  input  A3,
  input  A4,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4
);
  parameter INIT = 32'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  wire [4:0] dpra = {DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};
  reg [31:0] mem = INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986
    $setup(D , negedge WCLK &&& WE, 453);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L834
    $setup(WE, negedge WCLK, 654);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L800
    $setup(A0, negedge WCLK &&& WE, 245);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L798
    $setup(A1, negedge WCLK &&& WE, 208);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L796
    $setup(A2, negedge WCLK &&& WE, 147);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L794
    $setup(A3, negedge WCLK &&& WE, 68);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L792
    $setup(A4, negedge WCLK &&& WE, 66);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L981
    if (WE) (negedge WCLK => (SPO : D))    = 1153;
    if (WE) (negedge WCLK => (DPO : 1'bx)) = 1153;
    (A0 => SPO) = 642; (DPRA0 => DPO) = 642;
    (A1 => SPO) = 632; (DPRA1 => DPO) = 631;
    (A2 => SPO) = 472; (DPRA2 => DPO) = 472;
    (A3 => SPO) = 407; (DPRA3 => DPO) = 407;
    (A4 => SPO) = 238; (DPRA4 => DPO) = 238;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module RAM64X1D (
  output DPO, SPO,
  input  D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input  WCLK,
  input  WE,
  input  A0, A1, A2, A3, A4, A5,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5
);
  parameter INIT = 64'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [5:0] a = {A5, A4, A3, A2, A1, A0};
  wire [5:0] dpra = {DPRA5, DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};
  reg [63:0] mem = INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986
    $setup(D , posedge WCLK &&& !IS_WCLK_INVERTED && WE, 453);
    $setup(D , negedge WCLK &&&  IS_WCLK_INVERTED && WE, 453);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L834
    $setup(WE, posedge WCLK &&& !IS_WCLK_INVERTED, 654);
    $setup(WE, negedge WCLK &&&  IS_WCLK_INVERTED, 654);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L828
    $setup(A0, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 362);
    $setup(A0, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 362);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L826
    $setup(A1, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 245);
    $setup(A1, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 245);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L824
    $setup(A2, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 208);
    $setup(A2, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 208);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L822
    $setup(A3, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 147);
    $setup(A3, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 147);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L820
    $setup(A4, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 68);
    $setup(A4, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 68);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L818
    $setup(A5, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 66);
    $setup(A5, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 66);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L981
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (SPO : D))    = 1153;
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DPO : 1'bx)) = 1153;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (SPO : D))    = 1153;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DPO : 1'bx)) = 1153;
    (A0 => SPO) = 642; (DPRA0 => DPO) = 642;
    (A1 => SPO) = 632; (DPRA1 => DPO) = 631;
    (A2 => SPO) = 472; (DPRA2 => DPO) = 472;
    (A3 => SPO) = 407; (DPRA3 => DPO) = 407;
    (A4 => SPO) = 238; (DPRA4 => DPO) = 238;
    (A5 => SPO) = 127; (DPRA5 => DPO) = 127;
  endspecify
endmodule

module RAM64X1D_1 (
  output DPO, SPO,
  input  D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input  WCLK,
  input  WE,
  input  A0, A1, A2, A3, A4, A5,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5
);
  parameter INIT = 64'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [5:0] a = {A5, A4, A3, A2, A1, A0};
  wire [5:0] dpra = {DPRA5, DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};
  reg [63:0] mem = INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986
    $setup(D , negedge WCLK &&& WE, 453);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L834
    $setup(WE, negedge WCLK, 654);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L828
    $setup(A0, negedge WCLK &&& WE, 362);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L826
    $setup(A1, negedge WCLK &&& WE, 245);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L824
    $setup(A2, negedge WCLK &&& WE, 208);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L822
    $setup(A3, negedge WCLK &&& WE, 147);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L820
    $setup(A4, negedge WCLK &&& WE, 68);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L818
    $setup(A5, negedge WCLK &&& WE, 66);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L981
    if (WE) (negedge WCLK => (SPO : D))    = 1153;
    if (WE) (negedge WCLK => (DPO : 1'bx)) = 1153;
    (A0 => SPO) = 642; (DPRA0 => DPO) = 642;
    (A1 => SPO) = 632; (DPRA1 => DPO) = 631;
    (A2 => SPO) = 472; (DPRA2 => DPO) = 472;
    (A3 => SPO) = 407; (DPRA3 => DPO) = 407;
    (A4 => SPO) = 238; (DPRA4 => DPO) = 238;
    (A5 => SPO) = 127; (DPRA5 => DPO) = 127;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module RAM128X1D (
  output       DPO, SPO,
  input        D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input        WCLK,
  input        WE,
  input  [6:0] A,
  input  [6:0] DPRA
);
  parameter INIT = 128'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  reg [127:0] mem = INIT;
  assign SPO = mem[A];
  assign DPO = mem[DPRA];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[A] <= D;
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986
    $setup(D , posedge WCLK &&& !IS_WCLK_INVERTED && WE, 453);
    $setup(D , negedge WCLK &&&  IS_WCLK_INVERTED && WE, 453);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L834
    $setup(WE, posedge WCLK &&& !IS_WCLK_INVERTED, 654);
    $setup(WE, negedge WCLK &&&  IS_WCLK_INVERTED, 654);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L818-830
    $setup(A[0], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 616);
    $setup(A[0], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 616);
    $setup(A[1], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 362);
    $setup(A[1], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 362);
    $setup(A[2], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 245);
    $setup(A[2], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 245);
    $setup(A[3], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 208);
    $setup(A[3], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 208);
    $setup(A[4], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 147);
    $setup(A[4], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 147);
    $setup(A[5], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 68);
    $setup(A[5], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 68);
    $setup(A[6], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 66);
    $setup(A[6], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 66);
`ifndef __ICARUS__
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L981
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (SPO : D))    = 1153 + 217 /* to cross F7AMUX */ + 175 /* AMUX */;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DPO : 1'bx)) = 1153 + 223 /* to cross F7BMUX */ + 174 /* CMUX */;
    (A[0] => SPO) = 642 + 193 /* to cross F7AMUX */ + 175 /* AMUX */;
    (A[1] => SPO) = 631 + 193 /* to cross F7AMUX */ + 175 /* AMUX */;
    (A[2] => SPO) = 472 + 193 /* to cross F7AMUX */ + 175 /* AMUX */;
    (A[3] => SPO) = 407 + 193 /* to cross F7AMUX */ + 175 /* AMUX */;
    (A[4] => SPO) = 238 + 193 /* to cross F7AMUX */ + 175 /* AMUX */;
    (A[5] => SPO) = 127 + 193 /* to cross F7AMUX */ + 175 /* AMUX */;
    (A[6] => SPO) = 0 + 276 /* to select F7AMUX */ + 175 /* AMUX */;
    (DPRA[0] => DPO) = 642 + 223 /* to cross MUXF7 */ + 174 /* CMUX */;
    (DPRA[1] => DPO) = 631 + 223 /* to cross MUXF7 */ + 174 /* CMUX */;
    (DPRA[2] => DPO) = 472 + 223 /* to cross MUXF7 */ + 174 /* CMUX */;
    (DPRA[3] => DPO) = 407 + 223 /* to cross MUXF7 */ + 174 /* CMUX */;
    (DPRA[4] => DPO) = 238 + 223 /* to cross MUXF7 */ + 174 /* CMUX */;
    (DPRA[5] => DPO) = 127 + 223 /* to cross MUXF7 */ + 174 /* CMUX */;
    (DPRA[6] => DPO) = 0 + 296 /* to select MUXF7 */ + 174 /* CMUX */;
`endif
  endspecify
endmodule

module RAM256X1D (
  output DPO, SPO,
  input        D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input        WCLK,
  input        WE,
  input  [7:0] A, DPRA
);
  parameter INIT = 256'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  reg [255:0] mem = INIT;
  assign SPO = mem[A];
  assign DPO = mem[DPRA];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[A] <= D;
endmodule

// Multi port.

(* abc9_box, lib_whitebox *)
module RAM32M (
  output [1:0] DOA,
  output [1:0] DOB,
  output [1:0] DOC,
  output [1:0] DOD,
  input  [4:0] ADDRA, ADDRB, ADDRC,
  input  [4:0] ADDRD,
  input  [1:0] DIA,
  input  [1:0] DIB,
  input  [1:0] DIC,
  input  [1:0] DID,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input        WCLK,
  input        WE
);
  parameter [63:0] INIT_A = 64'h0000000000000000;
  parameter [63:0] INIT_B = 64'h0000000000000000;
  parameter [63:0] INIT_C = 64'h0000000000000000;
  parameter [63:0] INIT_D = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a = INIT_A;
  reg [63:0] mem_b = INIT_B;
  reg [63:0] mem_c = INIT_C;
  reg [63:0] mem_d = INIT_D;
  assign DOA = mem_a[2*ADDRA+:2];
  assign DOB = mem_b[2*ADDRB+:2];
  assign DOC = mem_c[2*ADDRC+:2];
  assign DOD = mem_d[2*ADDRD+:2];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      mem_a[2*ADDRD+:2] <= DIA;
      mem_b[2*ADDRD+:2] <= DIB;
      mem_c[2*ADDRD+:2] <= DIC;
      mem_d[2*ADDRD+:2] <= DID;
    end
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986
    $setup(ADDRD[0], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 245);
    $setup(ADDRD[0], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 245);
    $setup(ADDRD[1], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 208);
    $setup(ADDRD[1], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 208);
    $setup(ADDRD[2], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 147);
    $setup(ADDRD[2], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 147);
    $setup(ADDRD[3], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 68);
    $setup(ADDRD[3], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 68);
    $setup(ADDRD[4], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 66);
    $setup(ADDRD[4], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 66);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986-L988
    $setup(DIA[0], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 453);
    $setup(DIA[0], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 453);
    $setup(DIA[1], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 384);
    $setup(DIA[1], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 384);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L1054-L1056
    $setup(DIB[0], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 461);
    $setup(DIB[0], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 461);
    $setup(DIB[1], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 354);
    $setup(DIB[1], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 354);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L1122-L1124
    $setup(DIC[0], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 457);
    $setup(DIC[0], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 457);
    $setup(DIC[1], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 375);
    $setup(DIC[1], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 375);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L1190-L1192
    $setup(DID[0], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 310);
    $setup(DID[0], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 310);
    $setup(DID[1], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 334);
    $setup(DID[1], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 334);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L834
    $setup(WE, posedge WCLK &&& !IS_WCLK_INVERTED, 654);
    $setup(WE, negedge WCLK &&&  IS_WCLK_INVERTED, 654);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L889
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOA[0] : DIA[0])) = 1153;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOA[0] : DIA[0])) = 1153;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L857
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOA[1] : DIA[1])) = 1188;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOA[1] : DIA[1])) = 1188;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L957
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOB[0] : DIB[0])) = 1161;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOB[0] : DIB[0])) = 1161;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L925
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOB[1] : DIB[1])) = 1187;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOB[1] : DIB[1])) = 1187;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L993
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOC[0] : DIC[0])) = 1158;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOC[0] : DIC[0])) = 1158;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L1025
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOC[1] : DIC[1])) = 1180;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOC[1] : DIC[1])) = 1180;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L1093
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOD[0] : DID[0])) = 1163;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOD[0] : DID[0])) = 1163;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L1061
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOD[1] : DID[1])) = 1190;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOD[1] : DID[1])) = 1190;
    (ADDRA[0] *> DOA) = 642; (ADDRB[0] *> DOB) = 642; (ADDRC[0] *> DOC) = 642; (ADDRD[0] *> DOD) = 642;
    (ADDRA[1] *> DOA) = 631; (ADDRB[1] *> DOB) = 631; (ADDRC[1] *> DOC) = 631; (ADDRD[1] *> DOD) = 631;
    (ADDRA[2] *> DOA) = 472; (ADDRB[2] *> DOB) = 472; (ADDRC[2] *> DOC) = 472; (ADDRD[2] *> DOD) = 472;
    (ADDRA[3] *> DOA) = 407; (ADDRB[3] *> DOB) = 407; (ADDRC[3] *> DOC) = 407; (ADDRD[3] *> DOD) = 407;
    (ADDRA[4] *> DOA) = 238; (ADDRB[4] *> DOB) = 238; (ADDRC[4] *> DOC) = 238; (ADDRD[4] *> DOD) = 238;
  endspecify
endmodule

module RAM32M16 (
  output [1:0] DOA,
  output [1:0] DOB,
  output [1:0] DOC,
  output [1:0] DOD,
  output [1:0] DOE,
  output [1:0] DOF,
  output [1:0] DOG,
  output [1:0] DOH,
  input [4:0] ADDRA,
  input [4:0] ADDRB,
  input [4:0] ADDRC,
  input [4:0] ADDRD,
  input [4:0] ADDRE,
  input [4:0] ADDRF,
  input [4:0] ADDRG,
  input [4:0] ADDRH,
  input [1:0] DIA,
  input [1:0] DIB,
  input [1:0] DIC,
  input [1:0] DID,
  input [1:0] DIE,
  input [1:0] DIF,
  input [1:0] DIG,
  input [1:0] DIH,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [63:0] INIT_A = 64'h0000000000000000;
  parameter [63:0] INIT_B = 64'h0000000000000000;
  parameter [63:0] INIT_C = 64'h0000000000000000;
  parameter [63:0] INIT_D = 64'h0000000000000000;
  parameter [63:0] INIT_E = 64'h0000000000000000;
  parameter [63:0] INIT_F = 64'h0000000000000000;
  parameter [63:0] INIT_G = 64'h0000000000000000;
  parameter [63:0] INIT_H = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a = INIT_A;
  reg [63:0] mem_b = INIT_B;
  reg [63:0] mem_c = INIT_C;
  reg [63:0] mem_d = INIT_D;
  reg [63:0] mem_e = INIT_E;
  reg [63:0] mem_f = INIT_F;
  reg [63:0] mem_g = INIT_G;
  reg [63:0] mem_h = INIT_H;
  assign DOA = mem_a[2*ADDRA+:2];
  assign DOB = mem_b[2*ADDRB+:2];
  assign DOC = mem_c[2*ADDRC+:2];
  assign DOD = mem_d[2*ADDRD+:2];
  assign DOE = mem_e[2*ADDRE+:2];
  assign DOF = mem_f[2*ADDRF+:2];
  assign DOG = mem_g[2*ADDRG+:2];
  assign DOH = mem_h[2*ADDRH+:2];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      mem_a[2*ADDRH+:2] <= DIA;
      mem_b[2*ADDRH+:2] <= DIB;
      mem_c[2*ADDRH+:2] <= DIC;
      mem_d[2*ADDRH+:2] <= DID;
      mem_e[2*ADDRH+:2] <= DIE;
      mem_f[2*ADDRH+:2] <= DIF;
      mem_g[2*ADDRH+:2] <= DIG;
      mem_h[2*ADDRH+:2] <= DIH;
    end
endmodule

(* abc9_box, lib_whitebox *)
module RAM64M (
  output       DOA,
  output       DOB,
  output       DOC,
  output       DOD,
  input  [5:0] ADDRA, ADDRB, ADDRC,
  input  [5:0] ADDRD,
  input        DIA,
  input        DIB,
  input        DIC,
  input        DID,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input        WCLK,
  input        WE
);
  parameter [63:0] INIT_A = 64'h0000000000000000;
  parameter [63:0] INIT_B = 64'h0000000000000000;
  parameter [63:0] INIT_C = 64'h0000000000000000;
  parameter [63:0] INIT_D = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a = INIT_A;
  reg [63:0] mem_b = INIT_B;
  reg [63:0] mem_c = INIT_C;
  reg [63:0] mem_d = INIT_D;
  assign DOA = mem_a[ADDRA];
  assign DOB = mem_b[ADDRB];
  assign DOC = mem_c[ADDRC];
  assign DOD = mem_d[ADDRD];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      mem_a[ADDRD] <= DIA;
      mem_b[ADDRD] <= DIB;
      mem_c[ADDRD] <= DIC;
      mem_d[ADDRD] <= DID;
    end
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L818-L830
    $setup(ADDRD[0], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 362);
    $setup(ADDRD[0], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 362);
    $setup(ADDRD[1], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 245);
    $setup(ADDRD[1], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 245);
    $setup(ADDRD[2], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 208);
    $setup(ADDRD[2], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 208);
    $setup(ADDRD[3], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 147);
    $setup(ADDRD[3], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 147);
    $setup(ADDRD[4], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 68);
    $setup(ADDRD[4], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 68);
    $setup(ADDRD[5], posedge WCLK &&& !IS_WCLK_INVERTED && WE, 66);
    $setup(ADDRD[5], negedge WCLK &&&  IS_WCLK_INVERTED && WE, 66);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L986-L988
    $setup(DIA, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 384);
    $setup(DIA, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 384);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L1054-L1056
    $setup(DIB, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 354);
    $setup(DIB, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 354);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L1122-L1124
    $setup(DIC, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 375);
    $setup(DIC, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 375);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L1190-L1192
    $setup(DID, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 310);
    $setup(DID, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 310);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/31f51ac5ec7448dd6f79a8267f147123e4413c21/artix7/timings/CLBLM_R.sdf#L834
    $setup(WE, posedge WCLK &&& !IS_WCLK_INVERTED && WE, 654);
    $setup(WE, negedge WCLK &&&  IS_WCLK_INVERTED && WE, 654);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L889
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOA : DIA)) = 1153;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOA : DIA)) = 1153;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L957
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOB : DIB)) = 1161;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOB : DIB)) = 1161;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L1025
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOC : DIC)) = 1158;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOC : DIC)) = 1158;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L1093
    if (!IS_WCLK_INVERTED && WE) (posedge WCLK => (DOD : DID)) = 1163;
    if ( IS_WCLK_INVERTED && WE) (negedge WCLK => (DOD : DID)) = 1163;
    (ADDRA[0] => DOA) = 642; (ADDRB[0] => DOB) = 642; (ADDRC[0] => DOC) = 642; (ADDRD[0] => DOD) = 642;
    (ADDRA[1] => DOA) = 631; (ADDRB[1] => DOB) = 631; (ADDRC[1] => DOC) = 631; (ADDRD[1] => DOD) = 631;
    (ADDRA[2] => DOA) = 472; (ADDRB[2] => DOB) = 472; (ADDRC[2] => DOC) = 472; (ADDRD[2] => DOD) = 472;
    (ADDRA[3] => DOA) = 407; (ADDRB[3] => DOB) = 407; (ADDRC[3] => DOC) = 407; (ADDRD[3] => DOD) = 407;
    (ADDRA[4] => DOA) = 238; (ADDRB[4] => DOB) = 238; (ADDRC[4] => DOC) = 238; (ADDRD[4] => DOD) = 238;
  endspecify
endmodule

module RAM64M8 (
  output DOA,
  output DOB,
  output DOC,
  output DOD,
  output DOE,
  output DOF,
  output DOG,
  output DOH,
  input [5:0] ADDRA,
  input [5:0] ADDRB,
  input [5:0] ADDRC,
  input [5:0] ADDRD,
  input [5:0] ADDRE,
  input [5:0] ADDRF,
  input [5:0] ADDRG,
  input [5:0] ADDRH,
  input DIA,
  input DIB,
  input DIC,
  input DID,
  input DIE,
  input DIF,
  input DIG,
  input DIH,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);
  parameter [63:0] INIT_A = 64'h0000000000000000;
  parameter [63:0] INIT_B = 64'h0000000000000000;
  parameter [63:0] INIT_C = 64'h0000000000000000;
  parameter [63:0] INIT_D = 64'h0000000000000000;
  parameter [63:0] INIT_E = 64'h0000000000000000;
  parameter [63:0] INIT_F = 64'h0000000000000000;
  parameter [63:0] INIT_G = 64'h0000000000000000;
  parameter [63:0] INIT_H = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a = INIT_A;
  reg [63:0] mem_b = INIT_B;
  reg [63:0] mem_c = INIT_C;
  reg [63:0] mem_d = INIT_D;
  reg [63:0] mem_e = INIT_E;
  reg [63:0] mem_f = INIT_F;
  reg [63:0] mem_g = INIT_G;
  reg [63:0] mem_h = INIT_H;
  assign DOA = mem_a[ADDRA];
  assign DOB = mem_b[ADDRB];
  assign DOC = mem_c[ADDRC];
  assign DOD = mem_d[ADDRD];
  assign DOE = mem_e[ADDRE];
  assign DOF = mem_f[ADDRF];
  assign DOG = mem_g[ADDRG];
  assign DOH = mem_h[ADDRH];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      mem_a[ADDRH] <= DIA;
      mem_b[ADDRH] <= DIB;
      mem_c[ADDRH] <= DIC;
      mem_d[ADDRH] <= DID;
      mem_e[ADDRH] <= DIE;
      mem_f[ADDRH] <= DIF;
      mem_g[ADDRH] <= DIG;
      mem_h[ADDRH] <= DIH;
    end
endmodule

module RAM32X16DR8 (
  output       DOA,
  output       DOB,
  output       DOC,
  output       DOD,
  output       DOE,
  output       DOF,
  output       DOG,
  output [1:0] DOH,
  input  [5:0] ADDRA, ADDRB, ADDRC, ADDRD, ADDRE, ADDRF, ADDRG,
  input  [4:0] ADDRH,
  input  [1:0] DIA,
  input  [1:0] DIB,
  input  [1:0] DIC,
  input  [1:0] DID,
  input  [1:0] DIE,
  input  [1:0] DIF,
  input  [1:0] DIG,
  input  [1:0] DIH,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input        WCLK,
  input        WE
);
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a, mem_b, mem_c, mem_d, mem_e, mem_f, mem_g, mem_h;
  assign DOA = mem_a[ADDRA];
  assign DOB = mem_b[ADDRB];
  assign DOC = mem_c[ADDRC];
  assign DOD = mem_d[ADDRD];
  assign DOE = mem_e[ADDRE];
  assign DOF = mem_f[ADDRF];
  assign DOG = mem_g[ADDRG];
  assign DOH = mem_h[2*ADDRH+:2];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      mem_a[2*ADDRH+:2] <= DIA;
      mem_b[2*ADDRH+:2] <= DIB;
      mem_c[2*ADDRH+:2] <= DIC;
      mem_d[2*ADDRH+:2] <= DID;
      mem_e[2*ADDRH+:2] <= DIE;
      mem_f[2*ADDRH+:2] <= DIF;
      mem_g[2*ADDRH+:2] <= DIG;
      mem_h[2*ADDRH+:2] <= DIH;
    end
endmodule

module RAM64X8SW (
  output [7:0] O,
  input [5:0] A,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE,
  input [2:0] WSEL
);
  parameter [63:0] INIT_A = 64'h0000000000000000;
  parameter [63:0] INIT_B = 64'h0000000000000000;
  parameter [63:0] INIT_C = 64'h0000000000000000;
  parameter [63:0] INIT_D = 64'h0000000000000000;
  parameter [63:0] INIT_E = 64'h0000000000000000;
  parameter [63:0] INIT_F = 64'h0000000000000000;
  parameter [63:0] INIT_G = 64'h0000000000000000;
  parameter [63:0] INIT_H = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a = INIT_A;
  reg [63:0] mem_b = INIT_B;
  reg [63:0] mem_c = INIT_C;
  reg [63:0] mem_d = INIT_D;
  reg [63:0] mem_e = INIT_E;
  reg [63:0] mem_f = INIT_F;
  reg [63:0] mem_g = INIT_G;
  reg [63:0] mem_h = INIT_H;
  assign O[7] = mem_a[A];
  assign O[6] = mem_b[A];
  assign O[5] = mem_c[A];
  assign O[4] = mem_d[A];
  assign O[3] = mem_e[A];
  assign O[2] = mem_f[A];
  assign O[1] = mem_g[A];
  assign O[0] = mem_h[A];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      case (WSEL)
      3'b111: mem_a[A] <= D;
      3'b110: mem_b[A] <= D;
      3'b101: mem_c[A] <= D;
      3'b100: mem_d[A] <= D;
      3'b011: mem_e[A] <= D;
      3'b010: mem_f[A] <= D;
      3'b001: mem_g[A] <= D;
      3'b000: mem_h[A] <= D;
      endcase
    end
endmodule

// ROM.

module ROM16X1 (
  output O,
  input A0, A1, A2, A3
);
  parameter [15:0] INIT = 16'h0;
  assign O = INIT[{A3, A2, A1, A0}];
endmodule

module ROM32X1 (
  output O,
  input A0, A1, A2, A3, A4
);
  parameter [31:0] INIT = 32'h0;
  assign O = INIT[{A4, A3, A2, A1, A0}];
endmodule

module ROM64X1 (
  output O,
  input A0, A1, A2, A3, A4, A5
);
  parameter [63:0] INIT = 64'h0;
  assign O = INIT[{A5, A4, A3, A2, A1, A0}];
endmodule

module ROM128X1 (
  output O,
  input A0, A1, A2, A3, A4, A5, A6
);
  parameter [127:0] INIT = 128'h0;
  assign O = INIT[{A6, A5, A4, A3, A2, A1, A0}];
endmodule

module ROM256X1 (
  output O,
  input A0, A1, A2, A3, A4, A5, A6, A7
);
  parameter [255:0] INIT = 256'h0;
  assign O = INIT[{A7, A6, A5, A4, A3, A2, A1, A0}];
endmodule

// Shift registers.

(* abc9_box, lib_whitebox *)
module SRL16 (
  output Q,
  input A0, A1, A2, A3,
  (* clkbuf_sink *)
  input CLK,
  input D
);
  parameter [15:0] INIT = 16'h0000;

  reg [15:0] r = INIT;
  assign Q = r[{A3,A2,A1,A0}];
  always @(posedge CLK) r <= { r[14:0], D };

  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L905
    (posedge CLK => (Q : 1'bx)) = 1472;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L912
    $setup(D , posedge CLK, 173);
    (A0 => Q) = 631;
    (A1 => Q) = 472;
    (A2 => Q) = 407;
    (A3 => Q) = 238;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module SRL16E (
  output Q,
  input A0, A1, A2, A3, CE,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_CLK_INVERTED" *)
  input CLK,
  input D
);
  parameter [15:0] INIT = 16'h0000;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;

  reg [15:0] r = INIT;
  assign Q = r[{A3,A2,A1,A0}];
  generate
    if (IS_CLK_INVERTED) begin
      always @(negedge CLK) if (CE) r <= { r[14:0], D };
    end
    else
      always @(posedge CLK) if (CE) r <= { r[14:0], D };
  endgenerate
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L912
    $setup(D , posedge CLK &&& !IS_CLK_INVERTED, 173);
    $setup(D , negedge CLK &&&  IS_CLK_INVERTED, 173);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L905
    if (!IS_CLK_INVERTED && CE) (posedge CLK => (Q : D)) = 1472;
    if ( IS_CLK_INVERTED && CE) (negedge CLK => (Q : D)) = 1472;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L905
    if (!IS_CLK_INVERTED && CE) (posedge CLK => (Q : 1'bx)) = 1472;
    if ( IS_CLK_INVERTED && CE) (negedge CLK => (Q : 1'bx)) = 1472;
    (A0 => Q) = 631;
    (A1 => Q) = 472;
    (A2 => Q) = 407;
    (A3 => Q) = 238;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module SRLC16 (
  output Q,
  output Q15,
  input A0, A1, A2, A3,
  (* clkbuf_sink *)
  input CLK,
  input D
);
  parameter [15:0] INIT = 16'h0000;

  reg [15:0] r = INIT;
  assign Q15 = r[15];
  assign Q = r[{A3,A2,A1,A0}];
  always @(posedge CLK) r <= { r[14:0], D };

  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L912
    $setup(D , posedge CLK, 173);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L905
    (posedge CLK => (Q : 1'bx)) = 1472;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L904
    (posedge CLK => (Q15 : 1'bx)) = 1114;
    (A0 => Q) = 631;
    (A1 => Q) = 472;
    (A2 => Q) = 407;
    (A3 => Q) = 238;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module SRLC16E (
  output Q,
  output Q15,
  input A0, A1, A2, A3, CE,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_CLK_INVERTED" *)
  input CLK,
  input D
);
  parameter [15:0] INIT = 16'h0000;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;

  reg [15:0] r = INIT;
  assign Q15 = r[15];
  assign Q = r[{A3,A2,A1,A0}];
  generate
    if (IS_CLK_INVERTED) begin
      always @(negedge CLK) if (CE) r <= { r[14:0], D };
    end
    else
      always @(posedge CLK) if (CE) r <= { r[14:0], D };
  endgenerate
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L912
    $setup(D , posedge CLK &&& !IS_CLK_INVERTED, 173);
    $setup(D , negedge CLK &&&  IS_CLK_INVERTED, 173);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE, posedge CLK &&& !IS_CLK_INVERTED, 109);
    $setup(CE, negedge CLK &&&  IS_CLK_INVERTED, 109);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L905
    if (!IS_CLK_INVERTED && CE) (posedge CLK => (Q : D)) = 1472;
    if ( IS_CLK_INVERTED && CE) (negedge CLK => (Q : D)) = 1472;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L904
    if (!IS_CLK_INVERTED && CE) (posedge CLK => (Q15 : 1'bx)) = 1114;
    if ( IS_CLK_INVERTED && CE) (negedge CLK => (Q15 : 1'bx)) = 1114;
    (A0 => Q) = 631;
    (A1 => Q) = 472;
    (A2 => Q) = 407;
    (A3 => Q) = 238;
  endspecify
endmodule

(* abc9_box, lib_whitebox *)
module SRLC32E (
  output Q,
  output Q31,
  input [4:0] A,
  input CE,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_CLK_INVERTED" *)
  input CLK,
  input D
);
  parameter [31:0] INIT = 32'h00000000;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;

  reg [31:0] r = INIT;
  assign Q31 = r[31];
  assign Q = r[A];
  generate
    if (IS_CLK_INVERTED) begin
      always @(negedge CLK) if (CE) r <= { r[30:0], D };
    end
    else
      always @(posedge CLK) if (CE) r <= { r[30:0], D };
  endgenerate
  specify
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L912
    $setup(D , posedge CLK &&& !IS_CLK_INVERTED, 173);
    $setup(D , negedge CLK &&&  IS_CLK_INVERTED, 173);
    // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/slicel.sdf#L248
    $setup(CE, posedge CLK &&& !IS_CLK_INVERTED, 109);
    $setup(CE, negedge CLK &&&  IS_CLK_INVERTED, 109);
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L905
    if (!IS_CLK_INVERTED && CE) (posedge CLK => (Q : 1'bx)) = 1472;
    if ( IS_CLK_INVERTED && CE) (negedge CLK => (Q : 1'bx)) = 1472;
    // Max delay from: https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLM_R.sdf#L904
    if (!IS_CLK_INVERTED && CE) (posedge CLK => (Q31 : 1'bx)) = 1114;
    if ( IS_CLK_INVERTED && CE) (negedge CLK => (Q31 : 1'bx)) = 1114;
    (A[0] => Q) = 642;
    (A[1] => Q) = 631;
    (A[2] => Q) = 472;
    (A[3] => Q) = 407;
    (A[4] => Q) = 238;
  endspecify
endmodule

module CFGLUT5 (
  output CDO,
  output O5,
  output O6,
  input I4,
  input I3,
  input I2,
  input I1,
  input I0,
  input CDI,
  input CE,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_CLK_INVERTED" *)
  input CLK
);
  parameter [31:0] INIT = 32'h00000000;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;
  wire clk = CLK ^ IS_CLK_INVERTED;
  reg [31:0] r = INIT;
  assign CDO = r[31];
  assign O5 = r[{1'b0, I3, I2, I1, I0}];
  assign O6 = r[{I4, I3, I2, I1, I0}];
  always @(posedge clk) if (CE) r <= {r[30:0], CDI};
endmodule

// DSP

// Virtex 2, Virtex 2 Pro, Spartan 3.

// Asynchronous mode.

module MULT18X18 (
    input signed [17:0] A,
    input signed [17:0] B,
    output signed [35:0] P
);

assign P = A * B;

endmodule

// Synchronous mode.

module MULT18X18S (
    input signed [17:0] A,
    input signed [17:0] B,
    output reg signed [35:0] P,
    (* clkbuf_sink *)
    input C,
    input CE,
    input R
);

always @(posedge C)
	if (R)
		P <= 0;
	else if (CE)
		P <= A * B;

endmodule

// Spartan 3E, Spartan 3A.

module MULT18X18SIO (
    input signed [17:0] A,
    input signed [17:0] B,
    output signed [35:0] P,
    (* clkbuf_sink *)
    input CLK,
    input CEA,
    input CEB,
    input CEP,
    input RSTA,
    input RSTB,
    input RSTP,
    input signed [17:0] BCIN,
    output signed [17:0] BCOUT
);

parameter integer AREG = 1;
parameter integer BREG = 1;
parameter B_INPUT = "DIRECT";
parameter integer PREG = 1;

// The multiplier.
wire signed [35:0] P_MULT;
wire signed [17:0] A_MULT;
wire signed [17:0] B_MULT;
assign P_MULT = A_MULT * B_MULT;

// The cascade output.
assign BCOUT = B_MULT;

// The B input multiplexer.
wire signed [17:0] B_MUX;
assign B_MUX = (B_INPUT == "DIRECT") ? B : BCIN;

// The registers.
reg signed [17:0] A_REG;
reg signed [17:0] B_REG;
reg signed [35:0] P_REG;

initial begin
	A_REG = 0;
	B_REG = 0;
	P_REG = 0;
end

always @(posedge CLK) begin
	if (RSTA)
		A_REG <= 0;
	else if (CEA)
		A_REG <= A;

	if (RSTB)
		B_REG <= 0;
	else if (CEB)
		B_REG <= B_MUX;

	if (RSTP)
		P_REG <= 0;
	else if (CEP)
		P_REG <= P_MULT;
end

// The register enables.
assign A_MULT = (AREG == 1) ? A_REG : A;
assign B_MULT = (BREG == 1) ? B_REG : B_MUX;
assign P = (PREG == 1) ? P_REG : P_MULT;

endmodule

// Spartan 3A DSP.

module DSP48A (
    input signed [17:0] A,
    input signed [17:0] B,
    input signed [47:0] C,
    input signed [17:0] D,
    input signed [47:0] PCIN,
    input CARRYIN,
    input [7:0] OPMODE,
    output signed [47:0] P,
    output signed [17:0] BCOUT,
    output signed [47:0] PCOUT,
    output CARRYOUT,
    (* clkbuf_sink *)
    input CLK,
    input CEA,
    input CEB,
    input CEC,
    input CED,
    input CEM,
    input CECARRYIN,
    input CEOPMODE,
    input CEP,
    input RSTA,
    input RSTB,
    input RSTC,
    input RSTD,
    input RSTM,
    input RSTCARRYIN,
    input RSTOPMODE,
    input RSTP
);

parameter integer A0REG = 0;
parameter integer A1REG = 1;
parameter integer B0REG = 0;
parameter integer B1REG = 1;
parameter integer CREG = 1;
parameter integer DREG = 1;
parameter integer MREG = 1;
parameter integer CARRYINREG = 1;
parameter integer OPMODEREG = 1;
parameter integer PREG = 1;
parameter CARRYINSEL = "CARRYIN";
parameter RSTTYPE = "SYNC";

// This is a strict subset of Spartan 6 -- reuse its model.

/* verilator lint_off PINMISSING */
DSP48A1 #(
	.A0REG(A0REG),
	.A1REG(A1REG),
	.B0REG(B0REG),
	.B1REG(B1REG),
	.CREG(CREG),
	.DREG(DREG),
	.MREG(MREG),
	.CARRYINREG(CARRYINREG),
	.CARRYOUTREG(0),
	.OPMODEREG(OPMODEREG),
	.PREG(PREG),
	.CARRYINSEL(CARRYINSEL),
	.RSTTYPE(RSTTYPE)
) upgrade (
	.A(A),
	.B(B),
	.C(C),
	.D(D),
	.PCIN(PCIN),
	.CARRYIN(CARRYIN),
	.OPMODE(OPMODE),
	// M unconnected
	.P(P),
	.BCOUT(BCOUT),
	.PCOUT(PCOUT),
	.CARRYOUT(CARRYOUT),
	// CARRYOUTF unconnected
	.CLK(CLK),
	.CEA(CEA),
	.CEB(CEB),
	.CEC(CEC),
	.CED(CED),
	.CEM(CEM),
	.CECARRYIN(CECARRYIN),
	.CEOPMODE(CEOPMODE),
	.CEP(CEP),
	.RSTA(RSTA),
	.RSTB(RSTB),
	.RSTC(RSTC),
	.RSTD(RSTD),
	.RSTM(RSTM),
	.RSTCARRYIN(RSTCARRYIN),
	.RSTOPMODE(RSTOPMODE),
	.RSTP(RSTP)
);
/* verilator lint_on PINMISSING */

endmodule

// Spartan 6.

module DSP48A1 (
    input signed [17:0] A,
    input signed [17:0] B,
    input signed [47:0] C,
    input signed [17:0] D,
    input signed [47:0] PCIN,
    input CARRYIN,
    input [7:0] OPMODE,
    output signed [35:0] M,
    output signed [47:0] P,
    output signed [17:0] BCOUT,
    output signed [47:0] PCOUT,
    output CARRYOUT,
    output CARRYOUTF,
    (* clkbuf_sink *)
    input CLK,
    input CEA,
    input CEB,
    input CEC,
    input CED,
    input CEM,
    input CECARRYIN,
    input CEOPMODE,
    input CEP,
    input RSTA,
    input RSTB,
    input RSTC,
    input RSTD,
    input RSTM,
    input RSTCARRYIN,
    input RSTOPMODE,
    input RSTP
);

parameter integer A0REG = 0;
parameter integer A1REG = 1;
parameter integer B0REG = 0;
parameter integer B1REG = 1;
parameter integer CREG = 1;
parameter integer DREG = 1;
parameter integer MREG = 1;
parameter integer CARRYINREG = 1;
parameter integer CARRYOUTREG = 1;
parameter integer OPMODEREG = 1;
parameter integer PREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter RSTTYPE = "SYNC";

wire signed [35:0] M_MULT;
wire signed [47:0] P_IN;
wire signed [17:0] A0_OUT;
wire signed [17:0] B0_OUT;
wire signed [17:0] A1_OUT;
wire signed [17:0] B1_OUT;
wire signed [17:0] B1_IN;
wire signed [47:0] C_OUT;
wire signed [17:0] D_OUT;
wire signed [7:0] OPMODE_OUT;
wire CARRYIN_OUT;
wire CARRYOUT_IN;
wire CARRYIN_IN;
reg signed [47:0] XMUX;
reg signed [47:0] ZMUX;

// The registers.
reg signed [17:0] A0_REG;
reg signed [17:0] A1_REG;
reg signed [17:0] B0_REG;
reg signed [17:0] B1_REG;
reg signed [47:0] C_REG;
reg signed [17:0] D_REG;
reg signed [35:0] M_REG;
reg signed [47:0] P_REG;
reg [7:0] OPMODE_REG;
reg CARRYIN_REG;
reg CARRYOUT_REG;

initial begin
	A0_REG = 0;
	A1_REG = 0;
	B0_REG = 0;
	B1_REG = 0;
	C_REG = 0;
	D_REG = 0;
	M_REG = 0;
	P_REG = 0;
	OPMODE_REG = 0;
	CARRYIN_REG = 0;
	CARRYOUT_REG = 0;
end

generate

if (RSTTYPE == "SYNC") begin
	always @(posedge CLK) begin
		if (RSTA) begin
			A0_REG <= 0;
			A1_REG <= 0;
		end else if (CEA) begin
			A0_REG <= A;
			A1_REG <= A0_OUT;
		end
	end

	always @(posedge CLK) begin
		if (RSTB) begin
			B0_REG <= 0;
			B1_REG <= 0;
		end else if (CEB) begin
			B0_REG <= B;
			B1_REG <= B1_IN;
		end
	end

	always @(posedge CLK) begin
		if (RSTC) begin
			C_REG <= 0;
		end else if (CEC) begin
			C_REG <= C;
		end
	end

	always @(posedge CLK) begin
		if (RSTD) begin
			D_REG <= 0;
		end else if (CED) begin
			D_REG <= D;
		end
	end

	always @(posedge CLK) begin
		if (RSTM) begin
			M_REG <= 0;
		end else if (CEM) begin
			M_REG <= M_MULT;
		end
	end

	always @(posedge CLK) begin
		if (RSTP) begin
			P_REG <= 0;
		end else if (CEP) begin
			P_REG <= P_IN;
		end
	end

	always @(posedge CLK) begin
		if (RSTOPMODE) begin
			OPMODE_REG <= 0;
		end else if (CEOPMODE) begin
			OPMODE_REG <= OPMODE;
		end
	end

	always @(posedge CLK) begin
		if (RSTCARRYIN) begin
			CARRYIN_REG <= 0;
			CARRYOUT_REG <= 0;
		end else if (CECARRYIN) begin
			CARRYIN_REG <= CARRYIN_IN;
			CARRYOUT_REG <= CARRYOUT_IN;
		end
	end
end else begin
	always @(posedge CLK, posedge RSTA) begin
		if (RSTA) begin
			A0_REG <= 0;
			A1_REG <= 0;
		end else if (CEA) begin
			A0_REG <= A;
			A1_REG <= A0_OUT;
		end
	end

	always @(posedge CLK, posedge RSTB) begin
		if (RSTB) begin
			B0_REG <= 0;
			B1_REG <= 0;
		end else if (CEB) begin
			B0_REG <= B;
			B1_REG <= B1_IN;
		end
	end

	always @(posedge CLK, posedge RSTC) begin
		if (RSTC) begin
			C_REG <= 0;
		end else if (CEC) begin
			C_REG <= C;
		end
	end

	always @(posedge CLK, posedge RSTD) begin
		if (RSTD) begin
			D_REG <= 0;
		end else if (CED) begin
			D_REG <= D;
		end
	end

	always @(posedge CLK, posedge RSTM) begin
		if (RSTM) begin
			M_REG <= 0;
		end else if (CEM) begin
			M_REG <= M_MULT;
		end
	end

	always @(posedge CLK, posedge RSTP) begin
		if (RSTP) begin
			P_REG <= 0;
		end else if (CEP) begin
			P_REG <= P_IN;
		end
	end

	always @(posedge CLK, posedge RSTOPMODE) begin
		if (RSTOPMODE) begin
			OPMODE_REG <= 0;
		end else if (CEOPMODE) begin
			OPMODE_REG <= OPMODE;
		end
	end

	always @(posedge CLK, posedge RSTCARRYIN) begin
		if (RSTCARRYIN) begin
			CARRYIN_REG <= 0;
			CARRYOUT_REG <= 0;
		end else if (CECARRYIN) begin
			CARRYIN_REG <= CARRYIN_IN;
			CARRYOUT_REG <= CARRYOUT_IN;
		end
	end
end

endgenerate

// The register enables.
assign A0_OUT = (A0REG == 1) ? A0_REG : A;
assign A1_OUT = (A1REG == 1) ? A1_REG : A0_OUT;
assign B0_OUT = (B0REG == 1) ? B0_REG : B;
assign B1_OUT = (B1REG == 1) ? B1_REG : B1_IN;
assign C_OUT = (CREG == 1) ? C_REG : C;
assign D_OUT = (DREG == 1) ? D_REG : D;
assign M = (MREG == 1) ? M_REG : M_MULT;
assign P = (PREG == 1) ? P_REG : P_IN;
assign OPMODE_OUT = (OPMODEREG == 1) ? OPMODE_REG : OPMODE;
assign CARRYIN_OUT = (CARRYINREG == 1) ? CARRYIN_REG : CARRYIN_IN;
assign CARRYOUT = (CARRYOUTREG == 1) ? CARRYOUT_REG : CARRYOUT_IN;
assign CARRYOUTF = CARRYOUT;

// The pre-adder.
wire signed [17:0] PREADDER;
assign B1_IN = OPMODE_OUT[4] ? PREADDER : B0_OUT;
assign PREADDER = OPMODE_OUT[6] ? D_OUT - B0_OUT : D_OUT + B0_OUT;

// The multiplier.
assign M_MULT = A1_OUT * B1_OUT;

// The carry in selection.
assign CARRYIN_IN = (CARRYINSEL == "OPMODE5") ? OPMODE_OUT[5] : CARRYIN;

// The post-adder inputs.
always @* begin
	case (OPMODE_OUT[1:0])
		2'b00: XMUX <= 0;
		2'b01: XMUX <= M;
		2'b10: XMUX <= P;
		2'b11: XMUX <= {D_OUT[11:0], A1_OUT, B1_OUT};
		default: XMUX <= 48'hxxxxxxxxxxxx;
	endcase
end

always @* begin
	case (OPMODE_OUT[3:2])
		2'b00: ZMUX <= 0;
		2'b01: ZMUX <= PCIN;
		2'b10: ZMUX <= P;
		2'b11: ZMUX <= C_OUT;
		default: ZMUX <= 48'hxxxxxxxxxxxx;
	endcase
end

// The post-adder.
wire signed [48:0] X_EXT;
wire signed [48:0] Z_EXT;
assign X_EXT = {1'b0, XMUX};
assign Z_EXT = {1'b0, ZMUX};
assign {CARRYOUT_IN, P_IN} = OPMODE_OUT[7] ? (Z_EXT - (X_EXT + CARRYIN_OUT)) : (Z_EXT + X_EXT + CARRYIN_OUT);

// Cascade outputs.
assign BCOUT = B1_OUT;
assign PCOUT = P;

endmodule

module DSP48 (
    input signed [17:0] A,
    input signed [17:0] B,
    input signed [47:0] C,
    input signed [17:0] BCIN,
    input signed [47:0] PCIN,
    input CARRYIN,
    input [6:0] OPMODE,
    input SUBTRACT,
    input [1:0] CARRYINSEL,
    output signed [47:0] P,
    output signed [17:0] BCOUT,
    output signed [47:0] PCOUT,
    (* clkbuf_sink *)
    input CLK,
    input CEA,
    input CEB,
    input CEC,
    input CEM,
    input CECARRYIN,
    input CECINSUB,
    input CECTRL,
    input CEP,
    input RSTA,
    input RSTB,
    input RSTC,
    input RSTM,
    input RSTCARRYIN,
    input RSTCTRL,
    input RSTP
);

parameter integer AREG = 1;
parameter integer BREG = 1;
parameter integer CREG = 1;
parameter integer MREG = 1;
parameter integer PREG = 1;
parameter integer CARRYINREG = 1;
parameter integer CARRYINSELREG = 1;
parameter integer OPMODEREG = 1;
parameter integer SUBTRACTREG = 1;
parameter B_INPUT = "DIRECT";
parameter LEGACY_MODE = "MULT18X18S";

wire signed [17:0] A_OUT;
wire signed [17:0] B_OUT;
wire signed [47:0] C_OUT;
wire signed [35:0] M_MULT;
wire signed [35:0] M_OUT;
wire signed [47:0] P_IN;
wire [6:0] OPMODE_OUT;
wire [1:0] CARRYINSEL_OUT;
wire CARRYIN_OUT;
wire SUBTRACT_OUT;
reg INT_CARRYIN_XY;
reg INT_CARRYIN_Z;
reg signed [47:0] XMUX;
reg signed [47:0] YMUX;
wire signed [47:0] XYMUX;
reg signed [47:0] ZMUX;
reg CIN;

// The B input multiplexer.
wire signed [17:0] B_MUX;
assign B_MUX = (B_INPUT == "DIRECT") ? B : BCIN;

// The cascade output.
assign BCOUT = B_OUT;
assign PCOUT = P;

// The registers.
reg signed [17:0] A0_REG;
reg signed [17:0] A1_REG;
reg signed [17:0] B0_REG;
reg signed [17:0] B1_REG;
reg signed [47:0] C_REG;
reg signed [35:0] M_REG;
reg signed [47:0] P_REG;
reg [6:0] OPMODE_REG;
reg [1:0] CARRYINSEL_REG;
reg SUBTRACT_REG;
reg CARRYIN_REG;
reg INT_CARRYIN_XY_REG;

initial begin
	A0_REG = 0;
	A1_REG = 0;
	B0_REG = 0;
	B1_REG = 0;
	C_REG = 0;
	M_REG = 0;
	P_REG = 0;
	OPMODE_REG = 0;
	CARRYINSEL_REG = 0;
	SUBTRACT_REG = 0;
	CARRYIN_REG = 0;
	INT_CARRYIN_XY_REG = 0;
end

always @(posedge CLK) begin
	if (RSTA) begin
		A0_REG <= 0;
		A1_REG <= 0;
	end else if (CEA) begin
		A0_REG <= A;
		A1_REG <= A0_REG;
	end
	if (RSTB) begin
		B0_REG <= 0;
		B1_REG <= 0;
	end else if (CEB) begin
		B0_REG <= B_MUX;
		B1_REG <= B0_REG;
	end
	if (RSTC) begin
		C_REG <= 0;
	end else if (CEC) begin
		C_REG <= C;
	end
	if (RSTM) begin
		M_REG <= 0;
	end else if (CEM) begin
		M_REG <= M_MULT;
	end
	if (RSTP) begin
		P_REG <= 0;
	end else if (CEP) begin
		P_REG <= P_IN;
	end
	if (RSTCTRL) begin
		OPMODE_REG <= 0;
		CARRYINSEL_REG <= 0;
		SUBTRACT_REG <= 0;
	end else begin
		if (CECTRL) begin
			OPMODE_REG <= OPMODE;
			CARRYINSEL_REG <= CARRYINSEL;
		end
		if (CECINSUB)
			SUBTRACT_REG <= SUBTRACT;
	end
	if (RSTCARRYIN) begin
		CARRYIN_REG <= 0;
		INT_CARRYIN_XY_REG <= 0;
	end else begin
		if (CECINSUB)
			CARRYIN_REG <= CARRYIN;
		if (CECARRYIN)
			INT_CARRYIN_XY_REG <= INT_CARRYIN_XY;
	end
end

// The register enables.
assign A_OUT = (AREG == 2) ? A1_REG : (AREG == 1) ? A0_REG : A;
assign B_OUT = (BREG == 2) ? B1_REG : (BREG == 1) ? B0_REG : B_MUX;
assign C_OUT = (CREG == 1) ? C_REG : C;
assign M_OUT = (MREG == 1) ? M_REG : M_MULT;
assign P = (PREG == 1) ? P_REG : P_IN;
assign OPMODE_OUT = (OPMODEREG == 1) ? OPMODE_REG : OPMODE;
assign SUBTRACT_OUT = (SUBTRACTREG == 1) ? SUBTRACT_REG : SUBTRACT;
assign CARRYINSEL_OUT = (CARRYINSELREG == 1) ? CARRYINSEL_REG : CARRYINSEL;
assign CARRYIN_OUT = (CARRYINREG == 1) ? CARRYIN_REG : CARRYIN;

// The multiplier.
assign M_MULT = A_OUT * B_OUT;

// The post-adder inputs.
always @* begin
	case (OPMODE_OUT[1:0])
		2'b00: XMUX <= 0;
		2'b10: XMUX <= P;
		2'b11: XMUX <= {{12{A_OUT[17]}}, A_OUT, B_OUT};
		default: XMUX <= 48'hxxxxxxxxxxxx;
	endcase
	case (OPMODE_OUT[1:0])
		2'b01: INT_CARRYIN_XY <= A_OUT[17] ~^ B_OUT[17];
		2'b11: INT_CARRYIN_XY <= ~A_OUT[17];
		// TODO: not tested in hardware.
		default: INT_CARRYIN_XY <= A_OUT[17] ~^ B_OUT[17];
	endcase
end

always @* begin
	case (OPMODE_OUT[3:2])
		2'b00: YMUX <= 0;
		2'b11: YMUX <= C_OUT;
		default: YMUX <= 48'hxxxxxxxxxxxx;
	endcase
end

assign XYMUX = (OPMODE_OUT[3:0] == 4'b0101) ? M_OUT : (XMUX + YMUX);

always @* begin
	case (OPMODE_OUT[6:4])
		3'b000: ZMUX <= 0;
		3'b001: ZMUX <= PCIN;
		3'b010: ZMUX <= P;
		3'b011: ZMUX <= C_OUT;
		3'b101: ZMUX <= {{17{PCIN[47]}}, PCIN[47:17]};
		3'b110: ZMUX <= {{17{P[47]}}, P[47:17]};
		default: ZMUX <= 48'hxxxxxxxxxxxx;
	endcase
	// TODO: check how all this works on actual hw.
	if (OPMODE_OUT[1:0] == 2'b10)
		INT_CARRYIN_Z <= ~P[47];
	else
		case (OPMODE_OUT[6:4])
			3'b001: INT_CARRYIN_Z <= ~PCIN[47];
			3'b010: INT_CARRYIN_Z <= ~P[47];
			3'b101: INT_CARRYIN_Z <= ~PCIN[47];
			3'b110: INT_CARRYIN_Z <= ~P[47];
			default: INT_CARRYIN_Z <= 1'bx;
		endcase
end

always @* begin
	case (CARRYINSEL_OUT)
		2'b00: CIN <= CARRYIN_OUT;
		2'b01: CIN <= INT_CARRYIN_Z;
		2'b10: CIN <= INT_CARRYIN_XY;
		2'b11: CIN <= INT_CARRYIN_XY_REG;
		default: CIN <= 1'bx;
	endcase
end

// The post-adder.
assign P_IN = SUBTRACT_OUT ? (ZMUX - (XYMUX + CIN)) : (ZMUX + XYMUX + CIN);

endmodule

// TODO: DSP48E (Virtex 5).

// Virtex 6, Series 7.

`ifdef YOSYS
(* abc9_box=!(PREG || AREG || ADREG || BREG || CREG || DREG || MREG)
`ifdef ALLOW_WHITEBOX_DSP48E1
   // Do not make DSP48E1 a whitebox for ABC9 even if fully combinatorial, since it is a big complex block
   , lib_whitebox=!(PREG || AREG || ADREG || BREG || CREG || DREG || MREG || INMODEREG || OPMODEREG || ALUMODEREG || CARRYINREG || CARRYINSELREG)
`endif
*)
`endif
module DSP48E1 (
    output [29:0] ACOUT,
    output [17:0] BCOUT,
    output reg CARRYCASCOUT,
    output reg [3:0] CARRYOUT,
    output reg MULTSIGNOUT,
    output OVERFLOW,
    output reg signed [47:0] P,
    output reg PATTERNBDETECT,
    output reg PATTERNDETECT,
    output [47:0] PCOUT,
    output UNDERFLOW,
    input signed [29:0] A,
    input [29:0] ACIN,
    input [3:0] ALUMODE,
    input signed [17:0] B,
    input [17:0] BCIN,
    input [47:0] C,
    input CARRYCASCIN,
    input CARRYIN,
    input [2:0] CARRYINSEL,
    input CEA1,
    input CEA2,
    input CEAD,
    input CEALUMODE,
    input CEB1,
    input CEB2,
    input CEC,
    input CECARRYIN,
    input CECTRL,
    input CED,
    input CEINMODE,
    input CEM,
    input CEP,
    (* clkbuf_sink *) input CLK,
    input [24:0] D,
    input [4:0] INMODE,
    input MULTSIGNIN,
    input [6:0] OPMODE,
    input [47:0] PCIN,
    input RSTA,
    input RSTALLCARRYIN,
    input RSTALUMODE,
    input RSTB,
    input RSTC,
    input RSTCTRL,
    input RSTD,
    input RSTINMODE,
    input RSTM,
    input RSTP
);
    parameter integer ACASCREG = 1;
    parameter integer ADREG = 1;
    parameter integer ALUMODEREG = 1;
    parameter integer AREG = 1;
    parameter AUTORESET_PATDET = "NO_RESET";
    parameter A_INPUT = "DIRECT";
    parameter integer BCASCREG = 1;
    parameter integer BREG = 1;
    parameter B_INPUT = "DIRECT";
    parameter integer CARRYINREG = 1;
    parameter integer CARRYINSELREG = 1;
    parameter integer CREG = 1;
    parameter integer DREG = 1;
    parameter integer INMODEREG = 1;
    parameter integer MREG = 1;
    parameter integer OPMODEREG = 1;
    parameter integer PREG = 1;
    parameter SEL_MASK = "MASK";
    parameter SEL_PATTERN = "PATTERN";
    parameter USE_DPORT = "FALSE";
    parameter USE_MULT = "MULTIPLY";
    parameter USE_PATTERN_DETECT = "NO_PATDET";
    parameter USE_SIMD = "ONE48";
    parameter [47:0] MASK = 48'h3FFFFFFFFFFF;
    parameter [47:0] PATTERN = 48'h000000000000;
    parameter [3:0] IS_ALUMODE_INVERTED = 4'b0;
    parameter [0:0] IS_CARRYIN_INVERTED = 1'b0;
    parameter [0:0] IS_CLK_INVERTED = 1'b0;
    parameter [4:0] IS_INMODE_INVERTED = 5'b0;
    parameter [6:0] IS_OPMODE_INVERTED = 7'b0;

`ifdef YOSYS
    function integer \A.required ;
    begin
        if (AREG != 0)           \A.required =  254;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE") begin
            if (MREG != 0)       \A.required = 1416;
            else if (PREG != 0)  \A.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 3030 : 2739) ;
        end
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") begin
            // Worst-case from ADREG and MREG
            if (MREG != 0)       \A.required = 2400;
            else if (ADREG != 0) \A.required = 1283;
            else if (PREG != 0)  \A.required = 3723;
            else if (PREG != 0)  \A.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 4014 : 3723) ;
        end
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE") begin
            if (PREG != 0)       \A.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 1730 : 1441) ;
        end
    end
    endfunction
    function integer \B.required ;
    begin
        if (BREG != 0)      \B.required =  324;
        else if (MREG != 0) \B.required = 1285;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE") begin
            if (PREG != 0)  \B.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 2898 : 2608) ;
        end
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") begin
            if (PREG != 0)  \B.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 2898 : 2608) ;
        end
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE") begin
            if (PREG != 0)  \B.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 1718 : 1428) ;
        end
    end
    endfunction
    function integer \C.required ;
    begin
        if (CREG != 0)      \C.required =  168;
        else if (PREG != 0) \C.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 1534 : 1244) ;
    end
    endfunction
    function integer \D.required ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE") begin
        end
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") begin
            if (DREG != 0)       \D.required =  248;
            else if (ADREG != 0) \D.required = 1195;
            else if (MREG != 0)  \D.required = 2310;
            else if (PREG != 0)  \D.required = (USE_PATTERN_DETECT != "NO_PATDET" ? 3925 : 3635) ;
        end
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE") begin
        end
    end
    endfunction
    function integer \P.arrival ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE") begin
            if (PREG != 0)       \P.arrival =  329;
            // Worst-case from CREG and MREG
            else if (CREG != 0)  \P.arrival = 1687;
            else if (MREG != 0)  \P.arrival = 1671;
            // Worst-case from AREG and BREG
            else if (AREG != 0)  \P.arrival = 2952;
            else if (BREG != 0)  \P.arrival = 2813;
        end
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") begin
            if (PREG != 0)       \P.arrival =  329;
            // Worst-case from CREG and MREG
            else if (CREG != 0)  \P.arrival = 1687;
            else if (MREG != 0)  \P.arrival = 1671;
            // Worst-case from AREG, ADREG, BREG, DREG
            else if (AREG != 0)  \P.arrival = 3935;
            else if (DREG != 0)  \P.arrival = 3908;
            else if (ADREG != 0) \P.arrival = 2958;
            else if (BREG != 0)  \P.arrival = 2813;
        end
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE") begin
            if (PREG != 0)       \P.arrival =  329;
            // Worst-case from AREG, BREG, CREG
            else if (CREG != 0)  \P.arrival = 1687;
            else if (AREG != 0)  \P.arrival = 1632;
            else if (BREG != 0)  \P.arrival = 1616;
        end
    end
    endfunction
    function integer \PCOUT.arrival ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE") begin
            if (PREG != 0)       \PCOUT.arrival =  435;
            // Worst-case from CREG and MREG
            else if (CREG != 0)  \PCOUT.arrival = 1835;
            else if (MREG != 0)  \PCOUT.arrival = 1819;
            // Worst-case from AREG and BREG
            else if (AREG != 0)  \PCOUT.arrival = 3098;
            else if (BREG != 0)  \PCOUT.arrival = 2960;
        end
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") begin
            if (PREG != 0)       \PCOUT.arrival =  435;
            // Worst-case from CREG and MREG
            else if (CREG != 0)  \PCOUT.arrival = 1835;
            else if (MREG != 0)  \PCOUT.arrival = 1819;
            // Worst-case from AREG, ADREG, BREG, DREG
            else if (AREG != 0)  \PCOUT.arrival = 4083;
            else if (DREG != 0)  \PCOUT.arrival = 4056;
            else if (BREG != 0)  \PCOUT.arrival = 2960;
            else if (ADREG != 0) \PCOUT.arrival = 2859;
        end
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE") begin
            if (PREG != 0)       \PCOUT.arrival =  435;
            // Worst-case from AREG, BREG, CREG
            else if (CREG != 0)  \PCOUT.arrival = 1835;
            else if (AREG != 0)  \PCOUT.arrival = 1780;
            else if (BREG != 0)  \PCOUT.arrival = 1765;
        end
    end
    endfunction
    function integer \A.P.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE")     \A.P.comb = 2823;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") \A.P.comb = 3806;
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE")    \A.P.comb = 1523;
    end
    endfunction
    function integer \A.PCOUT.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE")     \A.PCOUT.comb = 2970;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") \A.PCOUT.comb = 3954;
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE")    \A.PCOUT.comb = 1671;
    end
    endfunction
    function integer \B.P.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE")     \B.P.comb = 2690;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") \B.P.comb = 2690;
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE")    \B.P.comb = 1509;
    end
    endfunction
    function integer \B.PCOUT.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE")     \B.PCOUT.comb = 2838;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") \B.PCOUT.comb = 2838;
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE")    \B.PCOUT.comb = 1658;
    end
    endfunction
    function integer \C.P.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE")     \C.P.comb = 1325;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") \C.P.comb = 1325;
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE")    \C.P.comb = 1325;
    end
    endfunction
    function integer \C.PCOUT.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "FALSE")     \C.PCOUT.comb = 1474;
        else if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE") \C.PCOUT.comb = 1474;
        else if (USE_MULT == "NONE" && USE_DPORT == "FALSE")    \C.PCOUT.comb = 1474;
    end
    endfunction
    function integer \D.P.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE")      \D.P.comb = 3717;
    end
    endfunction
    function integer \D.PCOUT.comb ;
    begin
        if (USE_MULT == "MULTIPLY" && USE_DPORT == "TRUE")      \D.PCOUT.comb = 3700;
    end
    endfunction

    generate
        if (PREG == 0 && MREG == 0 && AREG == 0 && ADREG == 0)
            specify
                (A *> P) =      \A.P.comb ();
                (A *> PCOUT) =  \A.PCOUT.comb ();
            endspecify
        else
            specify
                $setup(A, posedge CLK &&& !IS_CLK_INVERTED, \A.required () );
                $setup(A, negedge CLK &&&  IS_CLK_INVERTED, \A.required () );
            endspecify

        if (PREG == 0 && MREG == 0 && BREG == 0)
            specify
                (B *> P) =      \B.P.comb ();
                (B *> PCOUT) =  \B.PCOUT.comb ();
            endspecify
        else
            specify
                $setup(B, posedge CLK &&& !IS_CLK_INVERTED, \B.required () );
                $setup(B, negedge CLK &&&  IS_CLK_INVERTED, \B.required () );
            endspecify

        if (PREG == 0 && CREG == 0)
            specify
                (C *> P) =      \C.P.comb ();
                (C *> PCOUT) =  \C.PCOUT.comb ();
            endspecify
        else
            specify
                $setup(C, posedge CLK &&& !IS_CLK_INVERTED, \C.required () );
                $setup(C, negedge CLK &&&  IS_CLK_INVERTED, \C.required () );
            endspecify

        if (PREG == 0 && MREG == 0 && ADREG == 0 && DREG == 0)
            specify
                (D *> P) =      \D.P.comb ();
                (D *> PCOUT) =  \D.PCOUT.comb ();
            endspecify
        else
            specify
                $setup(D, posedge CLK &&& !IS_CLK_INVERTED, \D.required () );
                $setup(D, negedge CLK &&&  IS_CLK_INVERTED, \D.required () );
            endspecify

        if (PREG == 0)
            specify
                (PCIN *> P) =       1107;
                (PCIN *> PCOUT) =   1255;
            endspecify
        else
            specify
                $setup(PCIN, posedge CLK &&& !IS_CLK_INVERTED, USE_PATTERN_DETECT != "NO_PATDET" ? 1315 : 1025);
                $setup(PCIN, negedge CLK &&&  IS_CLK_INVERTED, USE_PATTERN_DETECT != "NO_PATDET" ? 1315 : 1025);
            endspecify

        if (PREG || AREG || ADREG || BREG || CREG || DREG || MREG)
            specify
                if (!IS_CLK_INVERTED && CEP) (posedge CLK => (P : 48'bx)) = \P.arrival () ;
                if ( IS_CLK_INVERTED && CEP) (negedge CLK => (P : 48'bx)) = \P.arrival () ;
                if (!IS_CLK_INVERTED && CEP) (posedge CLK => (PCOUT : 48'bx)) = \PCOUT.arrival () ;
                if ( IS_CLK_INVERTED && CEP) (negedge CLK => (PCOUT : 48'bx)) = \PCOUT.arrival () ;
            endspecify
    endgenerate
`endif

    initial begin
`ifndef YOSYS
        if (AUTORESET_PATDET != "NO_RESET") $fatal(1, "Unsupported AUTORESET_PATDET value");
        if (SEL_MASK != "MASK")     $fatal(1, "Unsupported SEL_MASK value");
        if (SEL_PATTERN != "PATTERN") $fatal(1, "Unsupported SEL_PATTERN value");
        if (USE_SIMD != "ONE48" && USE_SIMD != "TWO24" && USE_SIMD != "FOUR12")    $fatal(1, "Unsupported USE_SIMD value");
        if (IS_ALUMODE_INVERTED != 4'b0) $fatal(1, "Unsupported IS_ALUMODE_INVERTED value");
        if (IS_CARRYIN_INVERTED != 1'b0) $fatal(1, "Unsupported IS_CARRYIN_INVERTED value");
        if (IS_CLK_INVERTED != 1'b0) $fatal(1, "Unsupported IS_CLK_INVERTED value");
        if (IS_INMODE_INVERTED != 5'b0) $fatal(1, "Unsupported IS_INMODE_INVERTED value");
        if (IS_OPMODE_INVERTED != 7'b0) $fatal(1, "Unsupported IS_OPMODE_INVERTED value");
`endif
    end

    wire signed [29:0] A_muxed;
    wire signed [17:0] B_muxed;

    generate
        if (A_INPUT == "CASCADE") assign A_muxed = ACIN;
        else assign A_muxed = A;

        if (B_INPUT == "CASCADE") assign B_muxed = BCIN;
        else assign B_muxed = B;
    endgenerate

    reg signed [29:0] Ar1, Ar2;
    reg signed [24:0] Dr;
    reg signed [17:0] Br1, Br2;
    reg signed [47:0] Cr;
    reg        [4:0]  INMODEr;
    reg        [6:0]  OPMODEr;
    reg        [3:0]  ALUMODEr;
    reg        [2:0]  CARRYINSELr;

    generate
        // Configurable A register
        if (AREG == 2) begin
            initial Ar1 = 30'b0;
            initial Ar2 = 30'b0;
            always @(posedge CLK)
                if (RSTA) begin
                    Ar1 <= 30'b0;
                    Ar2 <= 30'b0;
                end else begin
                    if (CEA1) Ar1 <= A_muxed;
                    if (CEA2) Ar2 <= Ar1;
                end
        end else if (AREG == 1) begin
            //initial Ar1 = 30'b0;
            initial Ar2 = 30'b0;
            always @(posedge CLK)
                if (RSTA) begin
                    Ar1 <= 30'b0;
                    Ar2 <= 30'b0;
                end else begin
                    if (CEA1) Ar1 <= A_muxed;
                    if (CEA2) Ar2 <= A_muxed;
                end
        end else begin
            always @* Ar1 <= A_muxed;
            always @* Ar2 <= A_muxed;
        end

        // Configurable B register
        if (BREG == 2) begin
            initial Br1 = 25'b0;
            initial Br2 = 25'b0;
            always @(posedge CLK)
                if (RSTB) begin
                    Br1 <= 18'b0;
                    Br2 <= 18'b0;
                end else begin
                    if (CEB1) Br1 <= B_muxed;
                    if (CEB2) Br2 <= Br1;
                end
        end else if (BREG == 1) begin
            //initial Br1 = 18'b0;
            initial Br2 = 18'b0;
            always @(posedge CLK)
                if (RSTB) begin
                    Br1 <= 18'b0;
                    Br2 <= 18'b0;
                end else begin
                    if (CEB1) Br1 <= B_muxed;
                    if (CEB2) Br2 <= B_muxed;
                end
        end else begin
            always @* Br1 <= B_muxed;
            always @* Br2 <= B_muxed;
        end

        // C and D registers
        if (CREG == 1) initial Cr = 48'b0;
        if (CREG == 1) begin always @(posedge CLK) if (RSTC) Cr <= 48'b0; else if (CEC) Cr <= C; end
        else           always @* Cr <= C;

	if (DREG == 1) initial Dr = 25'b0;
        if (DREG == 1) begin always @(posedge CLK) if (RSTD) Dr <= 25'b0; else if (CED) Dr <= D; end
        else           always @* Dr <= D;

        // Control registers
        if (INMODEREG == 1) initial INMODEr = 5'b0;
        if (INMODEREG == 1) begin always @(posedge CLK) if (RSTINMODE) INMODEr <= 5'b0; else if (CEINMODE) INMODEr <= INMODE; end
        else           always @* INMODEr <= INMODE;
        if (OPMODEREG == 1) initial OPMODEr = 7'b0;
        if (OPMODEREG == 1) begin always @(posedge CLK) if (RSTCTRL) OPMODEr <= 7'b0; else if (CECTRL) OPMODEr <= OPMODE; end
        else           always @* OPMODEr <= OPMODE;
        if (ALUMODEREG == 1) initial ALUMODEr = 4'b0;
        if (ALUMODEREG == 1) begin always @(posedge CLK) if (RSTALUMODE) ALUMODEr <= 4'b0; else if (CEALUMODE) ALUMODEr <= ALUMODE; end
        else           always @* ALUMODEr <= ALUMODE;
        if (CARRYINSELREG == 1) initial CARRYINSELr = 3'b0;
        if (CARRYINSELREG == 1) begin always @(posedge CLK) if (RSTCTRL) CARRYINSELr <= 3'b0; else if (CECTRL) CARRYINSELr <= CARRYINSEL; end
        else           always @* CARRYINSELr <= CARRYINSEL;
    endgenerate

    // A and B cascade
    generate
        if (ACASCREG == 1 && AREG == 2) assign ACOUT = Ar1;
        else assign ACOUT = Ar2;
        if (BCASCREG == 1 && BREG == 2) assign BCOUT = Br1;
        else assign BCOUT = Br2;
    endgenerate

    // A/D input selection and pre-adder
    wire signed [24:0] Ar12_muxed = INMODEr[0] ? Ar1 : Ar2;
    wire signed [24:0] Ar12_gated = INMODEr[1] ? 25'b0 : Ar12_muxed;
    wire signed [24:0] Dr_gated   = INMODEr[2] ? Dr : 25'b0;
    wire signed [24:0] AD_result  = INMODEr[3] ? (Dr_gated - Ar12_gated) : (Dr_gated + Ar12_gated);
    reg  signed [24:0] ADr;

    generate
        if (ADREG == 1) initial ADr = 25'b0;
        if (ADREG == 1) begin always @(posedge CLK) if (RSTD) ADr <= 25'b0; else if (CEAD) ADr <= AD_result; end
        else            always @* ADr <= AD_result;
    endgenerate

    // 25x18 multiplier
    wire signed [24:0] A_MULT;
    wire signed [17:0] B_MULT = INMODEr[4] ? Br1 : Br2;
    generate
        if (USE_DPORT == "TRUE") assign A_MULT = ADr;
        else assign A_MULT = Ar12_gated;
    endgenerate

    wire signed [42:0] M = A_MULT * B_MULT;
    wire signed [42:0] Mx = (CARRYINSEL == 3'b010) ? 43'bx : M;
    reg  signed [42:0] Mr = 43'b0;

    // Multiplier result register
    generate
        if (MREG == 1) begin always @(posedge CLK) if (RSTM) Mr <= 43'b0; else if (CEM) Mr <= Mx; end
        else           always @* Mr <= Mx;
    endgenerate

    wire signed [42:0] Mrx = (CARRYINSELr == 3'b010) ? 43'bx : Mr;

    // X, Y and Z ALU inputs
    reg signed [47:0] X, Y, Z;

    always @* begin
        // X multiplexer
        case (OPMODEr[1:0])
            2'b00: X = 48'b0;
            2'b01: begin X = $signed(Mrx);
`ifndef YOSYS
                if (OPMODEr[3:2] != 2'b01) $fatal(1, "OPMODEr[3:2] must be 2'b01 when OPMODEr[1:0] is 2'b01");
`endif
            end
            2'b10:
                if (PREG == 1)
                    X = P;
                else begin
                    X = 48'bx;
`ifndef YOSYS
                    $fatal(1, "PREG must be 1 when OPMODEr[1:0] is 2'b10");
`endif
                end
            2'b11: X = $signed({Ar2, Br2});
            default: X = 48'bx;
        endcase

        // Y multiplexer
        case (OPMODEr[3:2])
            2'b00: Y = 48'b0;
            2'b01: begin Y = 48'b0; // FIXME: more accurate partial product modelling?
`ifndef YOSYS
                if (OPMODEr[1:0] != 2'b01) $fatal(1, "OPMODEr[1:0] must be 2'b01 when OPMODEr[3:2] is 2'b01");
`endif
            end
            2'b10: Y = {48{1'b1}};
            2'b11: Y = Cr;
            default: Y = 48'bx;
        endcase

        // Z multiplexer
        case (OPMODEr[6:4])
            3'b000: Z = 48'b0;
            3'b001: Z = PCIN;
            3'b010:
                if (PREG == 1)
                    Z = P;
                else begin
                    Z = 48'bx;
`ifndef YOSYS
                    $fatal(1, "PREG must be 1 when OPMODEr[6:4] is 3'b010");
`endif
                end
            3'b011: Z = Cr;
            3'b100:
                if (PREG == 1 && OPMODEr[3:0] === 4'b1000)
                    Z = P;
                else begin
                    Z = 48'bx;
`ifndef YOSYS
                    if (PREG != 1) $fatal(1, "PREG must be 1 when OPMODEr[6:4] is 3'b100");
                    if (OPMODEr[3:0] != 4'b1000) $fatal(1, "OPMODEr[3:0] must be 4'b1000 when OPMODEr[6:4] i0s 3'b100");
`endif
                end
            3'b101: Z = $signed(PCIN[47:17]);
            3'b110:
                if (PREG == 1)
                    Z = $signed(P[47:17]);
                else begin
                    Z = 48'bx;
`ifndef YOSYS
                    $fatal(1, "PREG must be 1 when OPMODEr[6:4] is 3'b110");
`endif
                end
            default: Z = 48'bx;
        endcase
    end

    // Carry in
    wire A24_xnor_B17d = A_MULT[24] ~^ B_MULT[17];
    reg CARRYINr, A24_xnor_B17;
    generate
        if (CARRYINREG == 1) initial CARRYINr = 1'b0;
        if (CARRYINREG == 1) begin always @(posedge CLK) if (RSTALLCARRYIN) CARRYINr <= 1'b0; else if (CECARRYIN) CARRYINr <= CARRYIN; end
        else                 always @* CARRYINr = CARRYIN;

        if (MREG == 1) initial A24_xnor_B17 = 1'b0;
        if (MREG == 1) begin always @(posedge CLK) if (RSTALLCARRYIN) A24_xnor_B17 <= 1'b0; else if (CEM) A24_xnor_B17 <= A24_xnor_B17d; end
        else                 always @* A24_xnor_B17 = A24_xnor_B17d;
    endgenerate

    reg cin_muxed;

    always @(*) begin
        case (CARRYINSELr)
            3'b000: cin_muxed = CARRYINr;
            3'b001: cin_muxed = ~PCIN[47];
            3'b010: cin_muxed = CARRYCASCIN;
            3'b011: cin_muxed = PCIN[47];
            3'b100:
                if (PREG == 1)
                    cin_muxed = CARRYCASCOUT;
                else begin
                    cin_muxed = 1'bx;
`ifndef YOSYS
                    $fatal(1, "PREG must be 1 when CARRYINSEL is 3'b100");
`endif
                end
            3'b101:
                if (PREG == 1)
                    cin_muxed = ~P[47];
                else begin
                    cin_muxed = 1'bx;
`ifndef YOSYS
                    $fatal(1, "PREG must be 1 when CARRYINSEL is 3'b101");
`endif
                end
            3'b110: cin_muxed = A24_xnor_B17;
            3'b111:
                if (PREG == 1)
                    cin_muxed = P[47];
                else begin
                    cin_muxed = 1'bx;
`ifndef YOSYS
                    $fatal(1, "PREG must be 1 when CARRYINSEL is 3'b111");
`endif
                end
            default: cin_muxed = 1'bx;
        endcase
    end

    wire alu_cin = (ALUMODEr[3] || ALUMODEr[2]) ? 1'b0 : cin_muxed;

    // ALU core
    wire [47:0] Z_muxinv = ALUMODEr[0] ? ~Z : Z;
    wire [47:0] xor_xyz = X ^ Y ^ Z_muxinv;
    wire [47:0] maj_xyz = (X & Y) | (X & Z_muxinv) | (Y & Z_muxinv);

    wire [47:0] xor_xyz_muxed = ALUMODEr[3] ? maj_xyz : xor_xyz;
    wire [47:0] maj_xyz_gated = ALUMODEr[2] ? 48'b0 :  maj_xyz;

    wire [48:0] maj_xyz_simd_gated;
    wire [3:0] int_carry_in, int_carry_out, ext_carry_out;
    wire [47:0] alu_sum;
    assign int_carry_in[0] = 1'b0;
    wire [3:0] carryout_reset;

    generate
        if (USE_SIMD == "FOUR12") begin
            assign maj_xyz_simd_gated = {
                    maj_xyz_gated[47:36],
                    1'b0, maj_xyz_gated[34:24],
                    1'b0, maj_xyz_gated[22:12],
                    1'b0, maj_xyz_gated[10:0],
                    alu_cin
                };
            assign int_carry_in[3:1] = 3'b000;
            assign ext_carry_out = {
                    int_carry_out[3],
                    maj_xyz_gated[35] ^ int_carry_out[2],
                    maj_xyz_gated[23] ^ int_carry_out[1],
                    maj_xyz_gated[11] ^ int_carry_out[0]
                };
            assign carryout_reset = 4'b0000;
        end else if (USE_SIMD == "TWO24") begin
            assign maj_xyz_simd_gated = {
                    maj_xyz_gated[47:24],
                    1'b0, maj_xyz_gated[22:0],
                    alu_cin
                };
            assign int_carry_in[3:1] = {int_carry_out[2], 1'b0, int_carry_out[0]};
            assign ext_carry_out = {
                    int_carry_out[3],
                    1'bx,
                    maj_xyz_gated[23] ^ int_carry_out[1],
                    1'bx
                };
            assign carryout_reset = 4'b0x0x;
        end else begin
            assign maj_xyz_simd_gated = {maj_xyz_gated, alu_cin};
            assign int_carry_in[3:1] = int_carry_out[2:0];
            assign ext_carry_out = {
                    int_carry_out[3],
                    3'bxxx
                };
            assign carryout_reset = 4'b0xxx;
        end

        genvar i;
        for (i = 0; i < 4; i = i + 1)
            assign {int_carry_out[i], alu_sum[i*12 +: 12]} = {1'b0, maj_xyz_simd_gated[i*12 +: ((i == 3) ? 13 : 12)]}
                                                              + xor_xyz_muxed[i*12 +: 12] + int_carry_in[i];
    endgenerate

    wire signed [47:0] Pd = ALUMODEr[1] ? ~alu_sum : alu_sum;
    wire [3:0] CARRYOUTd = (OPMODEr[3:0] == 4'b0101 || ALUMODEr[3:2] != 2'b00) ? 4'bxxxx :
                           ((ALUMODEr[0] & ALUMODEr[1]) ? ~ext_carry_out : ext_carry_out);
    wire CARRYCASCOUTd = ext_carry_out[3];
    wire MULTSIGNOUTd = Mrx[42];

    generate
        if (PREG == 1) begin
            initial P = 48'b0;
            initial CARRYOUT = carryout_reset;
            initial CARRYCASCOUT = 1'b0;
            initial MULTSIGNOUT = 1'b0;
            always @(posedge CLK)
                if (RSTP) begin
                    P <= 48'b0;
                    CARRYOUT <= carryout_reset;
                    CARRYCASCOUT <= 1'b0;
                    MULTSIGNOUT <= 1'b0;
                end else if (CEP) begin
                    P <= Pd;
                    CARRYOUT <= CARRYOUTd;
                    CARRYCASCOUT <= CARRYCASCOUTd;
                    MULTSIGNOUT <= MULTSIGNOUTd;
                end
        end else begin
            always @* begin
                P = Pd;
                CARRYOUT = CARRYOUTd;
                CARRYCASCOUT = CARRYCASCOUTd;
                MULTSIGNOUT = MULTSIGNOUTd;
            end
        end
    endgenerate

    assign PCOUT = P;

    generate
        wire PATTERNDETECTd, PATTERNBDETECTd;

        if (USE_PATTERN_DETECT == "PATDET") begin
            // TODO: Support SEL_PATTERN != "PATTERN" and SEL_MASK != "MASK
            assign PATTERNDETECTd = &(~(Pd ^ PATTERN) | MASK);
            assign PATTERNBDETECTd = &((Pd ^ PATTERN) | MASK);
        end else begin
            assign PATTERNDETECTd = 1'b1;
            assign PATTERNBDETECTd = 1'b1;
        end

        if (PREG == 1) begin
            reg PATTERNDETECTPAST, PATTERNBDETECTPAST;
            initial PATTERNDETECT = 1'b0;
            initial PATTERNBDETECT = 1'b0;
            initial PATTERNDETECTPAST = 1'b0;
            initial PATTERNBDETECTPAST = 1'b0;
            always @(posedge CLK)
                if (RSTP) begin
                    PATTERNDETECT <= 1'b0;
                    PATTERNBDETECT <= 1'b0;
                    PATTERNDETECTPAST <= 1'b0;
                    PATTERNBDETECTPAST <= 1'b0;
                end else if (CEP) begin
                    PATTERNDETECT <= PATTERNDETECTd;
                    PATTERNBDETECT <= PATTERNBDETECTd;
                    PATTERNDETECTPAST <= PATTERNDETECT;
                    PATTERNBDETECTPAST <= PATTERNBDETECT;
                end
            assign OVERFLOW = &{PATTERNDETECTPAST, ~PATTERNBDETECT, ~PATTERNDETECT};
            assign UNDERFLOW = &{PATTERNBDETECTPAST, ~PATTERNBDETECT, ~PATTERNDETECT};
        end else begin
            always @* begin
                PATTERNDETECT = PATTERNDETECTd;
                PATTERNBDETECT = PATTERNBDETECTd;
            end
            assign OVERFLOW = 1'bx, UNDERFLOW = 1'bx;
        end
    endgenerate

endmodule

// TODO: DSP48E2 (Ultrascale).

// Block RAM

module RAMB18E1 (
    (* clkbuf_sink *)
    (* invertible_pin = "IS_CLKARDCLK_INVERTED" *)
    input CLKARDCLK,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_CLKBWRCLK_INVERTED" *)
    input CLKBWRCLK,
    (* invertible_pin = "IS_ENARDEN_INVERTED" *)
    input ENARDEN,
    (* invertible_pin = "IS_ENBWREN_INVERTED" *)
    input ENBWREN,
    input REGCEAREGCE,
    input REGCEB,
    (* invertible_pin = "IS_RSTRAMARSTRAM_INVERTED" *)
    input RSTRAMARSTRAM,
    (* invertible_pin = "IS_RSTRAMB_INVERTED" *)
    input RSTRAMB,
    (* invertible_pin = "IS_RSTREGARSTREG_INVERTED" *)
    input RSTREGARSTREG,
    (* invertible_pin = "IS_RSTREGB_INVERTED" *)
    input RSTREGB,
    input [13:0] ADDRARDADDR,
    input [13:0] ADDRBWRADDR,
    input [15:0] DIADI,
    input [15:0] DIBDI,
    input [1:0] DIPADIP,
    input [1:0] DIPBDIP,
    input [1:0] WEA,
    input [3:0] WEBWE,
    output [15:0] DOADO,
    output [15:0] DOBDO,
    output [1:0] DOPADOP,
    output [1:0] DOPBDOP
);
    parameter integer DOA_REG = 0;
    parameter integer DOB_REG = 0;
    parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_A = 18'h0;
    parameter INIT_B = 18'h0;
    parameter INIT_FILE = "NONE";
    parameter RAM_MODE = "TDP";
    parameter RDADDR_COLLISION_HWCONFIG = "DELAYED_WRITE";
    parameter integer READ_WIDTH_A = 0;
    parameter integer READ_WIDTH_B = 0;
    parameter RSTREG_PRIORITY_A = "RSTREG";
    parameter RSTREG_PRIORITY_B = "RSTREG";
    parameter SIM_COLLISION_CHECK = "ALL";
    parameter SIM_DEVICE = "VIRTEX6";
    parameter SRVAL_A = 18'h0;
    parameter SRVAL_B = 18'h0;
    parameter WRITE_MODE_A = "WRITE_FIRST";
    parameter WRITE_MODE_B = "WRITE_FIRST";
    parameter integer WRITE_WIDTH_A = 0;
    parameter integer WRITE_WIDTH_B = 0;
    parameter IS_CLKARDCLK_INVERTED = 1'b0;
    parameter IS_CLKBWRCLK_INVERTED = 1'b0;
    parameter IS_ENARDEN_INVERTED = 1'b0;
    parameter IS_ENBWREN_INVERTED = 1'b0;
    parameter IS_RSTRAMARSTRAM_INVERTED = 1'b0;
    parameter IS_RSTRAMB_INVERTED = 1'b0;
    parameter IS_RSTREGARSTREG_INVERTED = 1'b0;
    parameter IS_RSTREGB_INVERTED = 1'b0;

    specify
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L13
        $setup(ADDRARDADDR, posedge CLKARDCLK, 566);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L17
        $setup(ADDRBWRADDR, posedge CLKBWRCLK, 566);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L19
        $setup(WEA, posedge CLKARDCLK, 532);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L21
        $setup(WEBWE, posedge CLKBWRCLK, 532);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L29
        $setup(REGCEAREGCE, posedge CLKARDCLK, 360);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L31
        $setup(RSTREGARSTREG, posedge CLKARDCLK, 342);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L49
        $setup(REGCEB, posedge CLKBWRCLK, 360);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L59
        $setup(RSTREGB, posedge CLKBWRCLK, 342);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L123
        $setup(DIADI, posedge CLKARDCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L133
        $setup(DIBDI, posedge CLKBWRCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L125
        $setup(DIPADIP, posedge CLKARDCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L135
        $setup(DIPBDIP, posedge CLKBWRCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L143
        if (&DOA_REG) (posedge CLKARDCLK => (DOADO : 16'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L144
        if (&DOA_REG) (posedge CLKARDCLK => (DOPADOP : 2'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L153
        if (|DOA_REG) (posedge CLKARDCLK => (DOADO : 16'bx)) = 882;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L154
        if (|DOA_REG) (posedge CLKARDCLK => (DOPADOP : 2'bx)) = 882;
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L163
        if (&DOB_REG) (posedge CLKBWRCLK => (DOBDO : 16'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L164
        if (&DOB_REG) (posedge CLKBWRCLK => (DOPBDOP : 2'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L173
        if (|DOB_REG) (posedge CLKBWRCLK => (DOBDO : 16'bx)) = 882;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L174
        if (|DOB_REG) (posedge CLKBWRCLK => (DOPBDOP : 2'bx)) = 882;
    endspecify
endmodule

module RAMB36E1 (
    output CASCADEOUTA,
    output CASCADEOUTB,
    output [31:0] DOADO,
    output [31:0] DOBDO,
    output [3:0] DOPADOP,
    output [3:0] DOPBDOP,
    output [7:0] ECCPARITY,
    output [8:0] RDADDRECC,
    output SBITERR,
    output DBITERR,
    (* invertible_pin = "IS_ENARDEN_INVERTED" *)
    input ENARDEN,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_CLKARDCLK_INVERTED" *)
    input CLKARDCLK,
    (* invertible_pin = "IS_RSTRAMARSTRAM_INVERTED" *)
    input RSTRAMARSTRAM,
    (* invertible_pin = "IS_RSTREGARSTREG_INVERTED" *)
    input RSTREGARSTREG,
    input CASCADEINA,
    input REGCEAREGCE,
    (* invertible_pin = "IS_ENBWREN_INVERTED" *)
    input ENBWREN,
    (* clkbuf_sink *)
    (* invertible_pin = "IS_CLKBWRCLK_INVERTED" *)
    input CLKBWRCLK,
    (* invertible_pin = "IS_RSTRAMB_INVERTED" *)
    input RSTRAMB,
    (* invertible_pin = "IS_RSTREGB_INVERTED" *)
    input RSTREGB,
    input CASCADEINB,
    input REGCEB,
    input INJECTDBITERR,
    input INJECTSBITERR,
    input [15:0] ADDRARDADDR,
    input [15:0] ADDRBWRADDR,
    input [31:0] DIADI,
    input [31:0] DIBDI,
    input [3:0] DIPADIP,
    input [3:0] DIPBDIP,
    input [3:0] WEA,
    input [7:0] WEBWE
);
    parameter integer DOA_REG = 0;
    parameter integer DOB_REG = 0;
    parameter EN_ECC_READ = "FALSE";
    parameter EN_ECC_WRITE = "FALSE";
    parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_40 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_41 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_42 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_43 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_44 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_45 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_46 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_47 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_48 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_49 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_4A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_4B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_4C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_4D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_4E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_4F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_50 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_51 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_52 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_53 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_54 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_55 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_56 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_57 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_58 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_59 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_5A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_5B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_5C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_5D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_5E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_5F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_60 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_61 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_62 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_63 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_64 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_65 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_66 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_67 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_68 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_69 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_6A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_6B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_6C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_6D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_6E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_6F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_70 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_71 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_72 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_73 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_74 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_75 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_76 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_77 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_78 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_79 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_7A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_7B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_7C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_7D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_7E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_7F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_A = 36'h0;
    parameter INIT_B = 36'h0;
    parameter INIT_FILE = "NONE";
    parameter RAM_EXTENSION_A = "NONE";
    parameter RAM_EXTENSION_B = "NONE";
    parameter RAM_MODE = "TDP";
    parameter RDADDR_COLLISION_HWCONFIG = "DELAYED_WRITE";
    parameter integer READ_WIDTH_A = 0;
    parameter integer READ_WIDTH_B = 0;
    parameter RSTREG_PRIORITY_A = "RSTREG";
    parameter RSTREG_PRIORITY_B = "RSTREG";
    parameter SIM_COLLISION_CHECK = "ALL";
    parameter SIM_DEVICE = "VIRTEX6";
    parameter SRVAL_A = 36'h0;
    parameter SRVAL_B = 36'h0;
    parameter WRITE_MODE_A = "WRITE_FIRST";
    parameter WRITE_MODE_B = "WRITE_FIRST";
    parameter integer WRITE_WIDTH_A = 0;
    parameter integer WRITE_WIDTH_B = 0;
    parameter IS_CLKARDCLK_INVERTED = 1'b0;
    parameter IS_CLKBWRCLK_INVERTED = 1'b0;
    parameter IS_ENARDEN_INVERTED = 1'b0;
    parameter IS_ENBWREN_INVERTED = 1'b0;
    parameter IS_RSTRAMARSTRAM_INVERTED = 1'b0;
    parameter IS_RSTRAMB_INVERTED = 1'b0;
    parameter IS_RSTREGARSTREG_INVERTED = 1'b0;
    parameter IS_RSTREGB_INVERTED = 1'b0;

    specify
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L13
        $setup(ADDRARDADDR, posedge CLKARDCLK, 566);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L17
        $setup(ADDRBWRADDR, posedge CLKBWRCLK, 566);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L19
        $setup(WEA, posedge CLKARDCLK, 532);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L21
        $setup(WEBWE, posedge CLKBWRCLK, 532);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L29
        $setup(REGCEAREGCE, posedge CLKARDCLK, 360);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L31
        $setup(RSTREGARSTREG, posedge CLKARDCLK, 342);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L49
        $setup(REGCEB, posedge CLKBWRCLK, 360);
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L59
        $setup(RSTREGB, posedge CLKBWRCLK, 342);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L123
        $setup(DIADI, posedge CLKARDCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L133
        $setup(DIBDI, posedge CLKBWRCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L125
        $setup(DIPADIP, posedge CLKARDCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L135
        $setup(DIPBDIP, posedge CLKBWRCLK, 737);
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L143
        if (&DOA_REG) (posedge CLKARDCLK => (DOADO : 32'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L144
        if (&DOA_REG) (posedge CLKARDCLK => (DOPADOP : 4'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L153
        if (|DOA_REG) (posedge CLKARDCLK => (DOADO : 32'bx)) = 882;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L154
        if (|DOA_REG) (posedge CLKARDCLK => (DOPADOP : 4'bx)) = 882;
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L163
        if (&DOB_REG) (posedge CLKBWRCLK => (DOBDO : 32'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/23c8b0851f979f0799318eaca90174413a46b257/artix7/timings/BRAM_L.sdf#L164
        if (&DOB_REG) (posedge CLKBWRCLK => (DOPBDOP : 4'bx)) = 2454;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L173
        if (|DOB_REG) (posedge CLKBWRCLK => (DOBDO : 32'bx)) = 882;
        // https://github.com/SymbiFlow/prjxray-db/blob/4bc6385ab300b1819848371f508185f57b649a0e/artix7/timings/BRAM_L.sdf#L174
        if (|DOB_REG) (posedge CLKBWRCLK => (DOPBDOP : 4'bx)) = 882;
    endspecify
endmodule


// Modules fpga_interconnect and LUT_K were taken from F4PGA installation:
// /f4pga/xc7/conda/envs/xc7/share/yosys/quicklogic/qlf_k6n10f/primitives_sim.v


// Copyright 2020-2022 F4PGA Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

`timescale 1ps/1ps

`default_nettype none

module fpga_interconnect(datain, dataout);
    input  wire datain;
    output wire dataout;

    assign dataout = datain;

    specify
        (datain => dataout) = 0;
    endspecify

endmodule

module LUT_K #(
    //The Look-up Table size (number of inputs)
    // supports 1<=K<=6
    parameter K = 5, 

    //The lut mask.  
    //Left-most (MSB) bit corresponds to all inputs logic one. 
    //Defaults to always false.
    parameter LUT_MASK={2**K{1'b0}} 
) (
    //input  wire [K-1:0] in,
    input  wire [5:0] in,
    output wire out
);

    wire    [63:0]  LUT_MASK_full;
    assign LUT_MASK_full =  (K == 6) ?  LUT_MASK[63:0] :
                            (K == 5) ?  {32'b0, LUT_MASK[31:0]} :
                            (K == 4) ?  {48'b0, LUT_MASK[15:0]} :
                            (K == 3) ?  {56'b0, LUT_MASK[7:0]} :
                            (K == 2) ?  {60'b0, LUT_MASK[3:0]} :
                                        {62'b0, LUT_MASK[1:0]} ;
    
    reg     [5:0]   in_full;
    always @(*)
        case(K)
            6:          in_full <= in[5:0];
            5:          in_full <= {1'b0, in[4:0]};
            4:          in_full <= {2'b0, in[3:0]};
            3:          in_full <= {3'b0, in[2:0]};
            2:          in_full <= {4'b0, in[1:0]};
            1:          in_full <= {5'b0, in[0]};
            default:    in_full <= in[5:0];
        endcase

    assign out = LUT_MASK_full[in_full];

    specify
        (in[0] => out) = 0;
        (in[1] => out) = 0;
        (in[2] => out) = 0;
        (in[3] => out) = 0;
        (in[4] => out) = 0;
        (in[5] => out) = 0;
    endspecify    

endmodule


// Modules below were taken from F4PGA installation:
// f4pga/xc7/share/f4pga/techmaps/xc7_vpr/techmap/cells_sim.v

// ============================================================================
// Define FFs required by VPR
//
module CE_VCC (output VCC);
wire VCC = 1;
endmodule

module SR_GND (output GND);
wire GND = 0;
endmodule

module SYN_OBUF(input I, output O);
  assign O = I;
endmodule

module SYN_IBUF(input I, output O);
  assign O = I;
endmodule

module FDRE_ZINI (output reg Q, input C, CE, D, R);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C) if (R) Q <= 1'b0; else if (CE) Q <= D;
    1'b1: always @(negedge C) if (R) Q <= 1'b0; else if (CE) Q <= D;
  endcase endgenerate
endmodule

module FDSE_ZINI (output reg Q, input C, CE, D, S);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C) if (S) Q <= 1'b1; else if (CE) Q <= D;
    1'b1: always @(negedge C) if (S) Q <= 1'b1; else if (CE) Q <= D;
  endcase endgenerate
endmodule

module FDCE_ZINI (output reg Q, input C, CE, D, CLR);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C, posedge CLR) if (CLR) Q <= 1'b0; else if (CE) Q <= D;
    1'b1: always @(negedge C, posedge CLR) if (CLR) Q <= 1'b0; else if (CE) Q <= D;
  endcase endgenerate
endmodule

module FDPE_ZINI (output reg Q, input C, CE, D, PRE);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C, posedge PRE) if (PRE) Q <= 1'b1; else if (CE) Q <= D;
    1'b1: always @(negedge C, posedge PRE) if (PRE) Q <= 1'b1; else if (CE) Q <= D;
  endcase endgenerate
endmodule

// ============================================================================
// Carry chain primitives

// Output CO directly
module CARRY_CO_DIRECT(input CO, input O, input S, input DI, output OUT);

assign OUT = CO;

endmodule

// Compute CO from O and S
module CARRY_CO_LUT(input CO, input O, input S, input DI, output OUT);

assign OUT = O ^ S;

endmodule

(* abc9_box, blackbox *)
module CARRY_COUT_PLUG(input CIN, output COUT);

assign COUT = CIN;

  specify
    (CIN => COUT) = 0;
  endspecify

endmodule

module CARRY4_VPR(O0, O1, O2, O3, CO0, CO1, CO2, CO3, CYINIT, CIN, DI0, DI1, DI2, DI3, S0, S1, S2, S3);
  parameter CYINIT_AX = 1'b0;
  parameter CYINIT_C0 = 1'b0;
  parameter CYINIT_C1 = 1'b0;

  (* DELAY_CONST_CYINIT="0.491e-9" *)
  (* DELAY_CONST_CIN="0.235e-9" *)
  (* DELAY_CONST_S0="0.223e-9" *)
  output wire O0;

  (* DELAY_CONST_CYINIT="0.613e-9" *)
  (* DELAY_CONST_CIN="0.348e-9" *)
  (* DELAY_CONST_S0="0.400e-9" *)
  (* DELAY_CONST_S1="0.205e-9" *)
  (* DELAY_CONST_DI0="0.337e-9" *)
  output wire O1;

  (* DELAY_CONST_CYINIT="0.600e-9" *)
  (* DELAY_CONST_CIN="0.256e-9" *)
  (* DELAY_CONST_S0="0.523e-9" *)
  (* DELAY_CONST_S1="0.558e-9" *)
  (* DELAY_CONST_S2="0.226e-9" *)
  (* DELAY_CONST_DI0="0.486e-9" *)
  (* DELAY_CONST_DI1="0.471e-9" *)
  output wire O2;

  (* DELAY_CONST_CYINIT="0.657e-9" *)
  (* DELAY_CONST_CIN="0.329e-9" *)
  (* DELAY_CONST_S0="0.582e-9" *)
  (* DELAY_CONST_S1="0.618e-9" *)
  (* DELAY_CONST_S2="0.330e-9" *)
  (* DELAY_CONST_S3="0.227e-9" *)
  (* DELAY_CONST_DI0="0.545e-9" *)
  (* DELAY_CONST_DI1="0.532e-9" *)
  (* DELAY_CONST_DI2="0.372e-9" *)
  output wire O3;

  (* DELAY_CONST_CYINIT="0.578e-9" *)
  (* DELAY_CONST_CIN="0.293e-9" *)
  (* DELAY_CONST_S0="0.340e-9" *)
  (* DELAY_CONST_DI0="0.329e-9" *)
  output wire CO0;

  (* DELAY_CONST_CYINIT="0.529e-9" *)
  (* DELAY_CONST_CIN="0.178e-9" *)
  (* DELAY_CONST_S0="0.433e-9" *)
  (* DELAY_CONST_S1="0.469e-9" *)
  (* DELAY_CONST_DI0="0.396e-9" *)
  (* DELAY_CONST_DI1="0.376e-9" *)
  output wire CO1;

  (* DELAY_CONST_CYINIT="0.617e-9" *)
  (* DELAY_CONST_CIN="0.250e-9" *)
  (* DELAY_CONST_S0="0.512e-9" *)
  (* DELAY_CONST_S1="0.548e-9" *)
  (* DELAY_CONST_S2="0.292e-9" *)
  (* DELAY_CONST_DI0="0.474e-9" *)
  (* DELAY_CONST_DI1="0.459e-9" *)
  (* DELAY_CONST_DI2="0.289e-9" *)
  output wire CO2;

  (* DELAY_CONST_CYINIT="0.580e-9" *)
  (* DELAY_CONST_CIN="0.114e-9" *)
  (* DELAY_CONST_S0="0.508e-9" *)
  (* DELAY_CONST_S1="0.528e-9" *)
  (* DELAY_CONST_S2="0.376e-9" *)
  (* DELAY_CONST_S3="0.380e-9" *)
  (* DELAY_CONST_DI0="0.456e-9" *)
  (* DELAY_CONST_DI1="0.443e-9" *)
  (* DELAY_CONST_DI2="0.324e-9" *)
  (* DELAY_CONST_DI3="0.327e-9" *)
  output wire CO3;

  input wire DI0, DI1, DI2, DI3;
  input wire S0, S1, S2, S3;

  input wire CYINIT;
  input wire CIN;

  wire CI0;
  wire CI1;
  wire CI2;
  wire CI3;
  wire CI4;

  assign CI0 = CYINIT_AX ? CYINIT :
               CYINIT_C1 ? 1'b1 :
               CYINIT_C0 ? 1'b0 :
               CIN;
  assign CI1 = S0 ? CI0 : DI0;
  assign CI2 = S1 ? CI1 : DI1;
  assign CI3 = S2 ? CI2 : DI2;
  assign CI4 = S3 ? CI3 : DI3;

  assign CO0 = CI1;
  assign CO1 = CI2;
  assign CO2 = CI3;
  assign CO3 = CI4;

  assign O0 = CI0 ^ S0;
  assign O1 = CI1 ^ S1;
  assign O2 = CI2 ^ S2;
  assign O3 = CI3 ^ S3;

  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L11-L46
    (CYINIT => O0) = 482;
    (S0     => O0) = 223;
    (CIN    => O0) = 222;
    (CYINIT => O1) = 598;
    (DI0    => O1) = 407;
    (S0     => O1) = 400;
    (S1     => O1) = 205;
    (CIN    => O1) = 334;
    (CYINIT => O2) = 584;
    (DI0    => O2) = 556;
    (DI1    => O2) = 537;
    (S0     => O2) = 523;
    (S1     => O2) = 558;
    (S2     => O2) = 226;
    (CIN    => O2) = 239;
    (CYINIT => O3) = 642;
    (DI0    => O3) = 615;
    (DI1    => O3) = 596;
    (DI2    => O3) = 438;
    (S0     => O3) = 582;
    (S1     => O3) = 618;
    (S2     => O3) = 330;
    (S3     => O3) = 227;
    (CIN    => O3) = 313;
    (CYINIT => CO0) = 536;
    (DI0    => CO0) = 379;
    (S0     => CO0) = 340;
    (CIN    => CO0) = 271;
    (CYINIT => CO1) = 494;
    (DI0    => CO1) = 465;
    (DI1    => CO1) = 445;
    (S0     => CO1) = 433;
    (S1     => CO1) = 469;
    (CIN    => CO1) = 157;
    (CYINIT => CO2) = 592;
    (DI0    => CO2) = 540;
    (DI1    => CO2) = 520;
    (DI2    => CO2) = 356;
    (S0     => CO2) = 512;
    (S1     => CO2) = 548;
    (S2     => CO2) = 292;
    (CIN    => CO2) = 228;
    (CYINIT => CO3) = 580;
    (DI0    => CO3) = 526;
    (DI1    => CO3) = 507;
    (DI2    => CO3) = 398;
    (DI3    => CO3) = 385;
    (S0     => CO3) = 508;
    (S1     => CO3) = 528;
    (S2     => CO3) = 378;
    (S3     => CO3) = 380;
    (CIN    => CO3) = 114;
  endspecify
endmodule

// ============================================================================
// Distributed RAMs

module DPRAM64_for_RAM128X1D (
  output O,
  input  DI, CLK, WE, WA7,
  input [5:0] A, WA
);
  parameter [63:0] INIT = 64'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  parameter HIGH_WA7_SELECT = 1'b0;
  wire [5:0] A;
  wire [5:0] WA;
  reg [63:0] mem;
  initial mem <= INIT;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE & (WA7 == HIGH_WA7_SELECT)) mem[WA] <= DI;
endmodule

module DPRAM64 (
  output O,
  input  DI, CLK, WE, WA7, WA8,
  input [5:0] A, WA
);
  parameter [63:0] INIT = 64'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  parameter WA7USED = 1'b0;
  parameter WA8USED = 1'b0;
  parameter HIGH_WA7_SELECT = 1'b0;
  parameter HIGH_WA8_SELECT = 1'b0;
  wire [5:0] A;
  wire [5:0] WA;
  reg [63:0] mem;
  initial mem <= INIT;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;

  wire WA7SELECT = !WA7USED | (WA7 == HIGH_WA7_SELECT);
  wire WA8SELECT = !WA8USED | (WA8 == HIGH_WA8_SELECT);
  wire address_selected = WA7SELECT & WA8SELECT;
  always @(posedge clk) if (WE & address_selected) mem[WA] <= DI;
endmodule

module DPRAM32 (
  output O,
  input  DI, CLK, WE,
  input [4:0] A, WA
);
  parameter [31:0] INIT_00 = 32'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [4:0] A;
  wire [4:0] WA;
  reg [31:0] mem;
  initial mem <= INIT_00;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) begin
    mem[WA] <= DI;
  end
endmodule

module SPRAM32 (
  output O,
  input  DI, CLK, WE,
  input [4:0] A, WA
);
  parameter [31:0] INIT_ZERO = 32'h0;
  parameter [31:0] INIT_00 = 32'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [4:0] A;
  wire [4:0] WA;
  reg [31:0] mem;
  initial mem <= INIT_00;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) begin
    mem[WA] <= DI;
  end
endmodule

module DI64_STUB (
    input DI, output DO
);
    assign DO = DI;
endmodule

// To ensure that all DRAMs are co-located within a SLICEM, this block is
// a simple passthrough black box to allow a pack pattern for dual port DRAMs.
module DRAM_2_OUTPUT_STUB(
    input SPO, DPO,
    output SPO_OUT, DPO_OUT
);
  wire SPO_OUT;
  wire DPO_OUT;
  assign SPO_OUT = SPO;
  assign DPO_OUT = DPO;
endmodule

module DRAM_4_OUTPUT_STUB(
    input DOA, DOB, DOC, DOD,
    output DOA_OUT, DOB_OUT, DOC_OUT, DOD_OUT
);
  assign DOA_OUT = DOA;
  assign DOB_OUT = DOB;
  assign DOC_OUT = DOC;
  assign DOD_OUT = DOD;
endmodule

module DRAM_8_OUTPUT_STUB(
    input DOA1, DOB1, DOC1, DOD1, DOA0, DOB0, DOC0, DOD0,
    output DOA1_OUT, DOB1_OUT, DOC1_OUT, DOD1_OUT, DOA0_OUT, DOB0_OUT, DOC0_OUT, DOD0_OUT
);
  assign DOA1_OUT = DOA1;
  assign DOB1_OUT = DOB1;
  assign DOC1_OUT = DOC1;
  assign DOD1_OUT = DOD1;
  assign DOA0_OUT = DOA0;
  assign DOB0_OUT = DOB0;
  assign DOC0_OUT = DOC0;
  assign DOD0_OUT = DOD0;
endmodule

// ============================================================================
// Block RAMs

module RAMB18E1_VPR (
	input CLKARDCLK,
	input CLKBWRCLK,
	input ENARDEN,
	input ENBWREN,
	input REGCLKARDRCLK,
	input REGCEAREGCE,
	input REGCEB,
	input REGCLKB,
	input RSTRAMARSTRAM,
	input RSTRAMB,
	input RSTREGARSTREG,
	input RSTREGB,

	input [1:0]  ADDRBTIEHIGH,
	input [13:0] ADDRBWRADDR,
	input [1:0]  ADDRATIEHIGH,
	input [13:0] ADDRARDADDR,
	input [15:0] DIADI,
	input [15:0] DIBDI,
	input [1:0] DIPADIP,
	input [1:0] DIPBDIP,
	input [3:0] WEA,
	input [7:0] WEBWE,

	output [15:0] DOADO,
	output [15:0] DOBDO,
	output [1:0] DOPADOP,
	output [1:0] DOPBDOP
);
	parameter IN_USE = 1'b0;

	parameter ZINIT_A = 18'h0;
	parameter ZINIT_B = 18'h0;

	parameter ZSRVAL_A = 18'h0;
	parameter ZSRVAL_B = 18'h0;

	parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

	parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

	parameter ZINV_CLKARDCLK = 1'b1;
	parameter ZINV_CLKBWRCLK = 1'b1;
	parameter ZINV_ENARDEN = 1'b1;
	parameter ZINV_ENBWREN = 1'b1;
	parameter ZINV_RSTRAMARSTRAM = 1'b1;
	parameter ZINV_RSTRAMB = 1'b1;
	parameter ZINV_RSTREGARSTREG = 1'b1;
	parameter ZINV_RSTREGB = 1'b1;
	parameter ZINV_REGCLKARDRCLK = 1'b1;
	parameter ZINV_REGCLKB = 1'b1;

	parameter DOA_REG = 1'b0;
	parameter DOB_REG = 1'b0;

	parameter integer SDP_READ_WIDTH_36 = 1'b0;
	parameter integer Y0_READ_WIDTH_A_18 = 1'b0;
	parameter integer Y1_READ_WIDTH_A_18 = 1'b0;
	parameter integer READ_WIDTH_A_9 = 1'b0;
	parameter integer READ_WIDTH_A_4 = 1'b0;
	parameter integer READ_WIDTH_A_2 = 1'b0;
	parameter integer Y0_READ_WIDTH_A_1 = 1'b0;
	parameter integer Y1_READ_WIDTH_A_1 = 1'b0;
	parameter integer READ_WIDTH_B_18 = 1'b0;
	parameter integer READ_WIDTH_B_9 = 1'b0;
	parameter integer READ_WIDTH_B_4 = 1'b0;
	parameter integer READ_WIDTH_B_2 = 1'b0;
	parameter integer READ_WIDTH_B_1 = 1'b1;

	parameter integer SDP_WRITE_WIDTH_36 = 1'b0;
	parameter integer WRITE_WIDTH_A_18 = 1'b0;
	parameter integer WRITE_WIDTH_A_9 = 1'b0;
	parameter integer WRITE_WIDTH_A_4 = 1'b0;
	parameter integer WRITE_WIDTH_A_2 = 1'b0;
	parameter integer WRITE_WIDTH_A_1 = 1'b1;
	parameter integer WRITE_WIDTH_B_18 = 1'b0;
	parameter integer WRITE_WIDTH_B_9 = 1'b0;
	parameter integer WRITE_WIDTH_B_4 = 1'b0;
	parameter integer WRITE_WIDTH_B_2 = 1'b0;
	parameter integer WRITE_WIDTH_B_1 = 1'b1;

	parameter WRITE_MODE_A_NO_CHANGE = 1'b0;
	parameter WRITE_MODE_A_READ_FIRST = 1'b0;
	parameter WRITE_MODE_B_NO_CHANGE = 1'b0;
	parameter WRITE_MODE_B_READ_FIRST = 1'b0;
endmodule

module RAMB36E1_PRIM (
        input CLKARDCLKU,           input CLKARDCLKL,
        input CLKBWRCLKU,           input CLKBWRCLKL,
        input ENARDENU,             input ENARDENL,
        input ENBWRENU,             input ENBWRENL,
        input REGCLKARDRCLKU,       input REGCLKARDRCLKL,
        input REGCEAREGCEU,         input REGCEAREGCEL,
        input REGCEBU,              input REGCEBL,
        input REGCLKBU,             input REGCLKBK,
        input RSTRAMARSTRAMU,       input RSTRAMARSTRAMLRST,
        input RSTRAMBU,             input RSTRAMBL,
        input RSTREGARSTREGU,       input RSTREGARSTREGL,
        input RSTREGBU,             input RSTREGBL,

        input [14:0] ADDRBWRADDRU,  input [15:0] ADDRBWRADDRL,
        input [14:0] ADDRARDADDRU,  input [15:0] ADDRARDADDRL,
        input [31:0] DIADI,
        input [31:0] DIBDI,
        input [3:0] DIPADIP,
        input [3:0] DIPBDIP,
        input [3:0] WEAU,           input [3:0] WEAL,
        input [7:0] WEBWEU,         input [7:0] WEBWEL,

        output [31:0] DOADO,
        output [31:0] DOBDO,
        output [3:0] DOPADOP,
        output [3:0] DOPBDOP
);
        parameter IN_USE = 1'b0;

        parameter ZINIT_A = 36'h0;
        parameter ZINIT_B = 36'h0;

        parameter ZSRVAL_A = 36'h0;
        parameter ZSRVAL_B = 36'h0;

        `define INIT_BLOCK(pre) \
        parameter ``pre``0 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``1 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``2 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``3 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``4 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``5 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``6 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``7 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``8 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``9 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``A = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``B = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``C = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``D = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``E = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``F = 256'h0000000000000000000000000000000000000000000000000000000000000000

        `INIT_BLOCK(INITP_0);
        `INIT_BLOCK(INIT_1);
        `INIT_BLOCK(INIT_2);
        `INIT_BLOCK(INIT_3);
        `INIT_BLOCK(INIT_4);
        `INIT_BLOCK(INIT_5);
        `INIT_BLOCK(INIT_6);
        `INIT_BLOCK(INIT_7);
        `undef INIT_BLOCK

        parameter ZINV_CLKARDCLK = 1'b1;
        parameter ZINV_CLKBWRCLK = 1'b1;
        parameter ZINV_ENARDEN = 1'b1;
        parameter ZINV_ENBWREN = 1'b1;
        parameter ZINV_RSTRAMARSTRAM = 1'b1;
        parameter ZINV_RSTRAMB = 1'b1;
        parameter ZINV_RSTREGARSTREG = 1'b1;
        parameter ZINV_RSTREGB = 1'b1;
        parameter ZINV_REGCLKARDRCLK = 1'b1;
        parameter ZINV_REGCLKB = 1'b1;

        parameter DOA_REG = 1'b0;
        parameter DOB_REG = 1'b0;

        parameter integer SDP_READ_WIDTH_72 = 1'b0;

        parameter integer READ_WIDTH_A_36 = 1'b0;
        parameter integer READ_WIDTH_A_18 = 1'b0;
        parameter integer READ_WIDTH_A_9 = 1'b0;
        parameter integer READ_WIDTH_A_4 = 1'b0;
        parameter integer READ_WIDTH_A_2 = 1'b0;
        parameter integer READ_WIDTH_A_1 = 1'b1;
        parameter integer BRAM36_READ_WIDTH_A_1 = 1'b0;

        parameter integer READ_WIDTH_B_18 = 1'b0;
        parameter integer READ_WIDTH_B_9 = 1'b0;
        parameter integer READ_WIDTH_B_4 = 1'b0;
        parameter integer READ_WIDTH_B_2 = 1'b0;
        parameter integer READ_WIDTH_B_1 = 1'b1;
        parameter integer BRAM36_READ_WIDTH_B_1 = 1'b0;

        parameter integer SDP_WRITE_WIDTH_72 = 1'b0;

        parameter integer WRITE_WIDTH_A_36 = 1'b0;
        parameter integer WRITE_WIDTH_A_18 = 1'b0;
        parameter integer WRITE_WIDTH_A_9 = 1'b0;
        parameter integer WRITE_WIDTH_A_4 = 1'b0;
        parameter integer WRITE_WIDTH_A_2 = 1'b0;
        parameter integer WRITE_WIDTH_A_1 = 1'b1;
        parameter integer BRAM36_WRITE_WIDTH_A_1 = 1'b0;

        parameter integer WRITE_WIDTH_B_18 = 1'b0;
        parameter integer WRITE_WIDTH_B_9 = 1'b0;
        parameter integer WRITE_WIDTH_B_4 = 1'b0;
        parameter integer WRITE_WIDTH_B_2 = 1'b0;
        parameter integer WRITE_WIDTH_B_1 = 1'b1;
        parameter integer BRAM36_WRITE_WIDTH_B_1 = 1'b0;

        parameter WRITE_MODE_A_NO_CHANGE = 1'b0;
        parameter WRITE_MODE_A_READ_FIRST = 1'b0;
        parameter WRITE_MODE_B_NO_CHANGE = 1'b0;
        parameter WRITE_MODE_B_READ_FIRST = 1'b0;
endmodule

// ============================================================================
// SRLs

// SRLC32E_VPR
module SRLC32E_VPR
(
input CLK, CE, D,
input [4:0] A,
output Q, Q31
);
  parameter [64:0] INIT = 64'd0;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;

  reg [31:0] r;
  integer i;

  initial for (i=0; i<32; i=i+1)
    r[i] <= INIT[2*i];

  assign Q31 = r[31];
  assign Q = r[A];

  generate begin
    if (IS_CLK_INVERTED) begin
      always @(negedge CLK) if (CE) r <= { r[30:0], D };
    end else begin
      always @(posedge CLK) if (CE) r <= { r[30:0], D };
    end
  end endgenerate

endmodule

// SRLC16E_VPR
module SRLC16E_VPR
(
input CLK, CE, D,
input A0, A1, A2, A3,
output Q, Q15
);
  parameter [15:0] INIT = 16'd0;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;

  reg [15:0] r = INIT;

  assign Q15 = r[15];
  assign Q = r[{A3,A2,A1,A0}];

  generate
    if (IS_CLK_INVERTED) begin
      always @(negedge CLK) if (CE) r <= { r[14:0], D };
    end else begin
      always @(posedge CLK) if (CE) r <= { r[14:0], D };
    end
  endgenerate

endmodule

// ============================================================================
// IO

module IBUF_VPR (
	input I,
	output O
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_IN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVDS_25_LVTTL_SSTL135_SSTL15_TMDS_33_IN_ONLY = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS25_LVCMOS33_LVTTL_IN = 1'b0;
  parameter [0:0] SSTL135_SSTL15_IN = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] IBUF_LOW_PWR = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";

  assign O = I;

endmodule

module OBUFT_VPR (
	input  I,
    input  T,
	output O
);

  parameter [0:0] LVCMOS12_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS12_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS25_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_LVCMOS18_LVCMOS25_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I24 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS33_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I4 = 1'b0;
  parameter [0:0] LVTTL_DRIVE_I24 = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter DRIVE = 0;
  parameter SLEW = "";

  assign O = (T == 1'b0) ? I : 1'bz;

endmodule


module IOBUF_VPR (
    input  I,
    input  T,
    output O,
    input  IOPAD_$inp,
    output IOPAD_$out
);

  parameter [0:0] LVCMOS12_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS12_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_IN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS25_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_LVCMOS18_LVCMOS25_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I24 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS25_LVCMOS33_LVTTL_IN = 1'b0;
  parameter [0:0] LVCMOS33_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I4 = 1'b0;
  parameter [0:0] LVTTL_DRIVE_I24 = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_IN = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] IBUF_LOW_PWR = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter DRIVE = 0;
  parameter SLEW = "";

  assign O = IOPAD_$inp;
  assign IOPAD_$out = (T == 1'b0) ? I : 1'bz;

endmodule


module OBUFTDS_M_VPR (
    input  I,
    input  T,
    output O,
    output OB
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_OUT = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;
  parameter [0:0] TMDS_33_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] TMDS_33_OUT = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  assign O  = (T == 1'b0) ?  I : 1'bz;
  assign OB = (T == 1'b0) ? !I : 1'bz;

endmodule

module OBUFTDS_S_VPR (
    input  IB,
    output OB
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  assign OB = IB;

endmodule


module IOBUFDS_M_VPR (
    input  I,
    input  T,
    output O,
    input  IOPAD_$inp,
    output IOPAD_$out,
    input  IB,
    output OB
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_OUT = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;
  parameter [0:0] TMDS_33_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] TMDS_33_OUT = 1'b0;
  parameter [0:0] LVDS_25_SSTL135_SSTL15_IN_DIFF = 1'b0;
  parameter [0:0] TMDS_33_IN_DIFF = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  reg O;
  always @(*) case ({IB, IOPAD_$inp})
  2'b00: O <= 1'bX;
  2'b01: O <= 1'b1;
  2'b10: O <= 1'b0;
  2'b11: O <= 1'bX;
  endcase

  assign IOPAD_$out = (T == 1'b0) ?  I : 1'bz;
  assign OB         = (T == 1'b0) ? !I : 1'bz;

endmodule

module IOBUFDS_S_VPR (
    input  IB,
    output OB,
    input  IOPAD_$inp,
    output IOPAD_$out
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_SSTL135_SSTL15_IN_DIFF = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  assign IOPAD_$out = IB;
  assign OB = IOPAD_$inp;

endmodule

(* whitebox *)
module T_INV (
    input  TI,
    output TO
);

  assign TO = ~TI;

endmodule

// ============================================================================
// I/OSERDES

module OSERDESE2_VPR (
  input CLK,
  input CLKDIV,
  input D1,
  input D2,
  input D3,
  input D4,
  input D5,
  input D6,
  input D7,
  input D8,
  input OCE,
  input RST,
  input T1,
  input T2,
  input T3,
  input T4,
  input TCE,
  output OFB,
  output OQ,
  output TFB,
  output TQ
);

  parameter [0:0] SERDES_MODE_SLAVE = 1'b0;

  parameter [0:0] TRISTATE_WIDTH_W4 = 1'b0;

  parameter [0:0] DATA_RATE_OQ_DDR = 1'b0;
  parameter [0:0] DATA_RATE_OQ_SDR = 1'b0;
  parameter [0:0] DATA_RATE_TQ_BUF = 1'b0;
  parameter [0:0] DATA_RATE_TQ_DDR = 1'b0;
  parameter [0:0] DATA_RATE_TQ_SDR = 1'b0;

  parameter [0:0] DATA_WIDTH_DDR_W6_8 = 1'b0;
  parameter [0:0] DATA_WIDTH_SDR_W2_4_5_6 = 1'b0;

  parameter [0:0] DATA_WIDTH_W2 = 1'b0;
  parameter [0:0] DATA_WIDTH_W3 = 1'b0;
  parameter [0:0] DATA_WIDTH_W4 = 1'b0;
  parameter [0:0] DATA_WIDTH_W5 = 1'b0;
  parameter [0:0] DATA_WIDTH_W6 = 1'b0;
  parameter [0:0] DATA_WIDTH_W7 = 1'b0;
  parameter [0:0] DATA_WIDTH_W8 = 1'b0;

  // Inverter parameters
  parameter [0:0] IS_CLKDIV_INVERTED = 1'b0;
  parameter [0:0] IS_D1_INVERTED = 1'b0;
  parameter [0:0] IS_D2_INVERTED = 1'b0;
  parameter [0:0] IS_D3_INVERTED = 1'b0;
  parameter [0:0] IS_D4_INVERTED = 1'b0;
  parameter [0:0] IS_D5_INVERTED = 1'b0;
  parameter [0:0] IS_D6_INVERTED = 1'b0;
  parameter [0:0] IS_D7_INVERTED = 1'b0;
  parameter [0:0] IS_D8_INVERTED = 1'b0;

  parameter [0:0] ZINV_CLK = 1'b0;
  parameter [0:0] ZINV_T1 = 1'b0;
  parameter [0:0] ZINV_T2 = 1'b0;
  parameter [0:0] ZINV_T3 = 1'b0;
  parameter [0:0] ZINV_T4 = 1'b0;

  parameter [0:0] ZINIT_OQ = 1'b0;
  parameter [0:0] ZINIT_TQ = 1'b0;
  parameter [0:0] ZSRVAL_OQ = 1'b0;
  parameter [0:0] ZSRVAL_TQ = 1'b0;
endmodule

module ISERDESE2_IDELAY_VPR (
  input  BITSLIP,
  input  CE1,
  input  CE2,
  input  CLK,
  input  CLKB,
  input  CLKDIV,
  input  RST,
  input  DDLY,
  output Q1,
  output Q2,
  output Q3,
  output Q4,
  output Q5,
  output Q6,
  output Q7,
  output Q8
  );

  parameter [0:0] MEMORY_DDR3_4     = 1'b0;
  parameter [0:0] MEMORY_DDR_4      = 1'b0;
  parameter [0:0] MEMORY_QDR_4      = 1'b0;

  parameter [0:0] NETWORKING_SDR_2  = 1'b0;
  parameter [0:0] NETWORKING_SDR_3  = 1'b0;
  parameter [0:0] NETWORKING_SDR_4  = 1'b0;
  parameter [0:0] NETWORKING_SDR_5  = 1'b0;
  parameter [0:0] NETWORKING_SDR_6  = 1'b0;
  parameter [0:0] NETWORKING_SDR_7  = 1'b0;
  parameter [0:0] NETWORKING_SDR_8  = 1'b0;

  parameter [0:0] NETWORKING_DDR_4  = 1'b0;
  parameter [0:0] NETWORKING_DDR_6  = 1'b0;
  parameter [0:0] NETWORKING_DDR_8  = 1'b0;
  parameter [0:0] NETWORKING_DDR_10 = 1'b0;
  parameter [0:0] NETWORKING_DDR_14 = 1'b0;

  parameter [0:0] OVERSAMPLE_DDR_4  = 1'b0;

  parameter [0:0] NUM_CE_N1 = 1'b0;
  parameter [0:0] NUM_CE_N2 = 1'b1;

  parameter [0:0] IOBDELAY_IFD = 1'b0;
  parameter [0:0] IOBDELAY_IBUF = 1'b0;

  parameter [0:0] ZINIT_Q1 = 1'b0;
  parameter [0:0] ZINIT_Q2 = 1'b0;
  parameter [0:0] ZINIT_Q3 = 1'b0;
  parameter [0:0] ZINIT_Q4 = 1'b0;

  parameter [0:0] ZSRVAL_Q1 = 1'b0;
  parameter [0:0] ZSRVAL_Q2 = 1'b0;
  parameter [0:0] ZSRVAL_Q3 = 1'b0;
  parameter [0:0] ZSRVAL_Q4 = 1'b0;

  parameter [0:0] ZINV_D = 1'b0;
  parameter [0:0] ZINV_C = 1'b0;

endmodule

module ISERDESE2_NO_IDELAY_VPR (
  input  BITSLIP,
  input  CE1,
  input  CE2,
  input  CLK,
  input  CLKB,
  input  CLKDIV,
  input  RST,
  input  D,
  output Q1,
  output Q2,
  output Q3,
  output Q4,
  output Q5,
  output Q6,
  output Q7,
  output Q8
  );

  parameter [0:0] MEMORY_DDR3_4     = 1'b0;
  parameter [0:0] MEMORY_DDR_4      = 1'b0;
  parameter [0:0] MEMORY_QDR_4      = 1'b0;

  parameter [0:0] NETWORKING_SDR_2  = 1'b0;
  parameter [0:0] NETWORKING_SDR_3  = 1'b0;
  parameter [0:0] NETWORKING_SDR_4  = 1'b0;
  parameter [0:0] NETWORKING_SDR_5  = 1'b0;
  parameter [0:0] NETWORKING_SDR_6  = 1'b0;
  parameter [0:0] NETWORKING_SDR_7  = 1'b0;
  parameter [0:0] NETWORKING_SDR_8  = 1'b0;

  parameter [0:0] NETWORKING_DDR_4  = 1'b0;
  parameter [0:0] NETWORKING_DDR_6  = 1'b0;
  parameter [0:0] NETWORKING_DDR_8  = 1'b0;
  parameter [0:0] NETWORKING_DDR_10 = 1'b0;
  parameter [0:0] NETWORKING_DDR_14 = 1'b0;

  parameter [0:0] OVERSAMPLE_DDR_4  = 1'b0;

  parameter [0:0] NUM_CE_N1 = 1'b0;
  parameter [0:0] NUM_CE_N2 = 1'b1;

  parameter [0:0] IOBDELAY_IFD = 1'b0;
  parameter [0:0] IOBDELAY_IBUF = 1'b0;

  parameter [0:0] ZINIT_Q1 = 1'b0;
  parameter [0:0] ZINIT_Q2 = 1'b0;
  parameter [0:0] ZINIT_Q3 = 1'b0;
  parameter [0:0] ZINIT_Q4 = 1'b0;

  parameter [0:0] ZSRVAL_Q1 = 1'b0;
  parameter [0:0] ZSRVAL_Q2 = 1'b0;
  parameter [0:0] ZSRVAL_Q3 = 1'b0;
  parameter [0:0] ZSRVAL_Q4 = 1'b0;

  parameter [0:0] ZINV_D = 1'b0;
  parameter [0:0] ZINV_C = 1'b0;

endmodule

// ============================================================================
// IDDR/ODDR

(* blackbox *)
module IDDR_VPR (
  input  CK,
  input  CKB,
  input  CE,
  input  SR,
  input  D,
  output Q1,
  output Q2
);

  parameter [0:0] ZINV_D = 1'b1;
  parameter [0:0] ZINV_C = 1'b1;

  parameter [0:0] SRTYPE_SYNC = 1'b0;

  parameter [0:0] SAME_EDGE     = 1'b0;
  parameter [0:0] OPPOSITE_EDGE = 1'b0;

  parameter [0:0] ZINIT_Q1   = 1'b0;
  parameter [0:0] ZINIT_Q2   = 1'b0;
  parameter [0:0] ZINIT_Q3   = 1'b0;
  parameter [0:0] ZINIT_Q4   = 1'b0;
  parameter [0:0] ZSRVAL_Q12 = 1'b0;
  parameter [0:0] ZSRVAL_Q34 = 1'b0;

endmodule

(* blackbox *)
module ODDR_VPR (
  input  CK,
  input  CE,
  input  SR,
  input  D1,
  input  D2,
  output Q
);

  parameter [0:0] ZINV_CLK = 1'b1;
  parameter [0:0] ZINV_D1  = 1'b1;
  parameter [0:0] ZINV_D2  = 1'b1;
  
  parameter [0:0] INV_D1  = 1'b0;
  parameter [0:0] INV_D2  = 1'b0;

  parameter [0:0] SRTYPE_SYNC = 1'b0;
  parameter [0:0] SAME_EDGE   = 1'b1;

  parameter [0:0] ZINIT_Q  = 1'b1;
  parameter [0:0] ZSRVAL_Q = 1'b1;

endmodule

// ============================================================================
// IDELAYE2

module IDELAYE2_VPR (
  input C,
  input CE,
  input CINVCTRL,
  input CNTVALUEIN0,
  input CNTVALUEIN1,
  input CNTVALUEIN2,
  input CNTVALUEIN3,
  input CNTVALUEIN4,
  input DATAIN,
  input IDATAIN,
  input INC,
  input LD,
  input LDPIPEEN,
  input REGRST,

  output CNTVALUEOUT0,
  output CNTVALUEOUT1,
  output CNTVALUEOUT2,
  output CNTVALUEOUT3,
  output CNTVALUEOUT4,
  output DATAOUT
  );

  parameter [0:0] IN_USE = 1'b0;

  parameter [4:0] IDELAY_VALUE = 5'b00000;
  parameter [4:0] ZIDELAY_VALUE = 5'b11111;

  parameter [0:0] PIPE_SEL = 1'b0;
  parameter [0:0] CINVCTRL_SEL = 1'b0;
  parameter [0:0] DELAY_SRC_DATAIN = 1'b0;
  parameter [0:0] DELAY_SRC_IDATAIN = 1'b0;
  parameter [0:0] HIGH_PERFORMANCE_MODE = 1'b0;

  parameter [0:0] DELAY_TYPE_FIXED = 1'b0;
  parameter [0:0] DELAY_TYPE_VAR_LOAD = 1'b0;
  parameter [0:0] DELAY_TYPE_VARIABLE = 1'b0;

  parameter [0:0] IS_DATAIN_INVERTED = 1'b0;
  parameter [0:0] IS_IDATAIN_INVERTED = 1'b0;

endmodule

// ============================================================================
// Clock Buffers

// BUFGCTRL_VPR
module BUFGCTRL_VPR
(
output O,
input I0, input I1,
input S0, input S1,
input CE0, input CE1,
input IGNORE0, input IGNORE1
);

  parameter [0:0] INIT_OUT = 1'b0;
  parameter [0:0] ZPRESELECT_I0 = 1'b0;
  parameter [0:0] ZPRESELECT_I1 = 1'b0;
  parameter [0:0] ZINV_CE0 = 1'b0;
  parameter [0:0] ZINV_CE1 = 1'b0;
  parameter [0:0] ZINV_S0 = 1'b0;
  parameter [0:0] ZINV_S1 = 1'b0;
  parameter [0:0] IS_IGNORE0_INVERTED = 1'b0;
  parameter [0:0] IS_IGNORE1_INVERTED = 1'b0;

  wire I0_internal = ((CE0 ^ !ZINV_CE0) ? I0 : INIT_OUT);
  wire I1_internal = ((CE1 ^ !ZINV_CE1) ? I1 : INIT_OUT);
  wire S0_true = (S0 ^ !ZINV_S0);
  wire S1_true = (S1 ^ !ZINV_S1);

  assign O = S0_true ? I0_internal : (S1_true ? I1_internal : INIT_OUT);

endmodule

// BUFHCE_VPR
module BUFHCE_VPR
(
output O,
input I,
input CE
);

  parameter [0:0] INIT_OUT = 1'b0;
  parameter CE_TYPE = "SYNC";
  parameter [0:0] ZINV_CE = 1'b0;

  wire I = ((CE ^ !ZINV_CE) ? I : INIT_OUT);

  assign O = I;

endmodule

// ============================================================================
// CMT

// PLLE2_ADV_VPR
(* blackbox *)
module PLLE2_ADV_VPR
(
input         CLKFBIN,
input         CLKIN1,
input         CLKIN2,
input         CLKINSEL,

output        CLKFBOUT,
output        CLKOUT0,
output        CLKOUT1,
output        CLKOUT2,
output        CLKOUT3,
output        CLKOUT4,
output        CLKOUT5,

input         PWRDWN,
input         RST,
output        LOCKED,

input         DCLK,
input         DEN,
input         DWE,
output        DRDY,
input  [ 6:0] DADDR,
input  [15:0] DI,
output [15:0] DO
);

  parameter [0:0] INV_CLKINSEL = 1'd0;
  parameter [0:0] ZINV_PWRDWN = 1'd0;
  parameter [0:0] ZINV_RST = 1'd1;

  parameter [0:0] STARTUP_WAIT = 1'd0;

  // Tables
  parameter [9:0] TABLE = 10'd0;
  parameter [39:0] LKTABLE = 40'd0;
  parameter [15:0] POWER_REG = 16'd0;
  parameter [11:0] FILTREG1_RESERVED = 12'd0;
  parameter [9:0] FILTREG2_RESERVED = 10'd0;
  parameter [5:0] LOCKREG1_RESERVED = 6'd0;
  parameter [0:0] LOCKREG2_RESERVED = 1'b0;
  parameter [0:0] LOCKREG3_RESERVED = 1'b0;

  // DIVCLK
  parameter [5:0] DIVCLK_DIVCLK_HIGH_TIME = 6'd0;
  parameter [5:0] DIVCLK_DIVCLK_LOW_TIME = 6'd0;
  parameter [0:0] DIVCLK_DIVCLK_NO_COUNT = 1'b1;
  parameter [0:0] DIVCLK_DIVCLK_EDGE = 1'b0;

  // CLKFBOUT
  parameter [5:0] CLKFBOUT_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKFBOUT_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKFBOUT_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT0
  parameter [5:0] CLKOUT0_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT0_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT0_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT1
  parameter [5:0] CLKOUT1_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT1_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT1_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT1_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT1_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT1_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT1_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT1_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT2
  parameter [5:0] CLKOUT2_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT2_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT2_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT2_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT2_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT2_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT2_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT2_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT3
  parameter [5:0] CLKOUT3_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT3_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT3_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT3_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT3_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT3_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT3_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT3_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT4
  parameter [5:0] CLKOUT4_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT4_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT4_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT4_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT4_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT4_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT4_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT4_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT5
  parameter [5:0] CLKOUT5_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT5_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT5_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT5_CLKOUT2_NO_COUNT = 1'b1;


  // TODO: Compensation parameters

  // TODO: How to simulate a PLL in verilog (i.e. the VCO) ???

endmodule

// MMCME2_ADV_VPR
(* blackbox *)
module MMCME2_ADV_VPR
(
input     CLKFBIN,
input     CLKIN1,
input     CLKIN2,
input     CLKINSEL,

output    CLKFBOUT,
output    CLKFBOUTB,
output    CLKOUT0,
output    CLKOUT0B,
output    CLKOUT1,
output    CLKOUT1B,
output    CLKOUT2,
output    CLKOUT2B,
output    CLKOUT3,
output    CLKOUT3B,
output    CLKOUT4,
output    CLKOUT5,
output    CLKOUT6,

output    CLKINSTOPPED,
output    CLKFBSTOPPED,

input     PWRDWN,
input     RST,
output    LOCKED,

input     PSCLK,
input     PSEN,
input     PSINCDEC,
output    PSDONE,

input     DCLK,
input     DEN,
input     DWE,
output    DRDY,
input     DADDR0,
input     DADDR1,
input     DADDR2,
input     DADDR3,
input     DADDR4,
input     DADDR5,
input     DADDR6,
input     DI0,
input     DI1,
input     DI2,
input     DI3,
input     DI4,
input     DI5,
input     DI6,
input     DI7,
input     DI8,
input     DI9,
input     DI10,
input     DI11,
input     DI12,
input     DI13,
input     DI14,
input     DI15,
output    DO0,
output    DO1,
output    DO2,
output    DO3,
output    DO4,
output    DO5,
output    DO6,
output    DO7,
output    DO8,
output    DO9,
output    DO10,
output    DO11,
output    DO12,
output    DO13,
output    DO14,
output    DO15
);

  parameter [0:0] INV_CLKINSEL = 1'd0;
  parameter [0:0] ZINV_PWRDWN = 1'd0;
  parameter [0:0] ZINV_RST = 1'd1;
  parameter [0:0] ZINV_PSEN = 1'd1;
  parameter [0:0] ZINV_PSINCDEC = 1'd1;

  parameter [0:0] STARTUP_WAIT = 1'd0;

  // Compensation
  parameter [0:0] COMP_ZHOLD = 1'd0;
  parameter [0:0] COMP_Z_ZHOLD = 1'd0;

  // Spread spectrum
  parameter [0:0] SS_EN = 1'd0;
  // TODO: Fuzz and add more

  // Tables
  parameter [9:0] TABLE = 10'd0;
  parameter [39:0] LKTABLE = 40'd0;
  parameter [15:0] POWER_REG = 16'd0;
  parameter [11:0] FILTREG1_RESERVED = 12'd0;
  parameter [9:0] FILTREG2_RESERVED = 10'd0;
  parameter [5:0] LOCKREG1_RESERVED = 6'd0;
  parameter [0:0] LOCKREG2_RESERVED = 1'b0;
  parameter [0:0] LOCKREG3_RESERVED = 1'b0;

  // DIVCLK
  parameter [5:0] DIVCLK_DIVCLK_HIGH_TIME = 6'd0;
  parameter [5:0] DIVCLK_DIVCLK_LOW_TIME = 6'd0;
  parameter [0:0] DIVCLK_DIVCLK_NO_COUNT = 1'b1;
  parameter [0:0] DIVCLK_DIVCLK_EDGE = 1'b0;

  // CLKFBOUT
  parameter [5:0] CLKFBOUT_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKFBOUT_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKFBOUT_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT0
  parameter [5:0] CLKOUT0_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT0_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT0_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT1
  parameter [5:0] CLKOUT1_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT1_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT1_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT1_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT1_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT2
  parameter [5:0] CLKOUT2_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT2_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT2_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT2_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT2_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT3
  parameter [5:0] CLKOUT3_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT3_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT3_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT3_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT3_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT4
  parameter [5:0] CLKOUT4_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT4_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT4_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT4_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT4_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT5
  parameter [5:0] CLKOUT5_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT5_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT5_CLKOUT2_FRACTIONAL_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRACTIONAL_EDGE = 1'b0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRACTIONAL_FRAC_WF_F = 1'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRACTIONAL_NO_COUNT = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT1_FRACTIONAL_PHASE_MUX_F = 3'd0;

  // CLKOUT6
  parameter [5:0] CLKOUT6_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT6_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT6_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT6_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT6_CLKOUT2_FRACTIONAL_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT6_CLKOUT2_FRACTIONAL_EDGE = 1'b0;
  parameter [0:0] CLKOUT6_CLKOUT2_FRACTIONAL_FRAC_WF_F = 1'd0;
  parameter [0:0] CLKOUT6_CLKOUT2_FRACTIONAL_NO_COUNT = 1'b0;
  parameter [2:0] CLKOUT6_CLKOUT1_FRACTIONAL_PHASE_MUX_F = 3'd0;

endmodule

// ============================================================================
// The Zynq PS7

(* blackbox *)
module PS7_VPR (
  input  [ 3: 0] DDRARB,
  input          DMA0ACLK,
  input          DMA0DAREADY,
  output [ 1: 0] DMA0DATYPE,
  output         DMA0DAVALID,
  input          DMA0DRLAST,
  output         DMA0DRREADY,
  input  [ 1: 0] DMA0DRTYPE,
  input          DMA0DRVALID,
  output         DMA0RSTN,
  input          DMA1ACLK,
  input          DMA1DAREADY,
  output [ 1: 0] DMA1DATYPE,
  output         DMA1DAVALID,
  input          DMA1DRLAST,
  output         DMA1DRREADY,
  input  [ 1: 0] DMA1DRTYPE,
  input          DMA1DRVALID,
  output         DMA1RSTN,
  input          DMA2ACLK,
  input          DMA2DAREADY,
  output [ 1: 0] DMA2DATYPE,
  output         DMA2DAVALID,
  input          DMA2DRLAST,
  output         DMA2DRREADY,
  input  [ 1: 0] DMA2DRTYPE,
  input          DMA2DRVALID,
  output         DMA2RSTN,
  input          DMA3ACLK,
  input          DMA3DAREADY,
  output [ 1: 0] DMA3DATYPE,
  output         DMA3DAVALID,
  input          DMA3DRLAST,
  output         DMA3DRREADY,
  input  [ 1: 0] DMA3DRTYPE,
  input          DMA3DRVALID,
  output         DMA3RSTN,
  input          EMIOCAN0PHYRX,
  output         EMIOCAN0PHYTX,
  input          EMIOCAN1PHYRX,
  output         EMIOCAN1PHYTX,
  input          EMIOENET0EXTINTIN,
  input          EMIOENET0GMIICOL,
  input          EMIOENET0GMIICRS,
  input          EMIOENET0GMIIRXCLK,
  input  [ 7: 0] EMIOENET0GMIIRXD,
  input          EMIOENET0GMIIRXDV,
  input          EMIOENET0GMIIRXER,
  input          EMIOENET0GMIITXCLK,
  output [ 7: 0] EMIOENET0GMIITXD,
  output         EMIOENET0GMIITXEN,
  output         EMIOENET0GMIITXER,
  input          EMIOENET0MDIOI,
  output         EMIOENET0MDIOMDC,
  output         EMIOENET0MDIOO,
  output         EMIOENET0MDIOTN,
  output         EMIOENET0PTPDELAYREQRX,
  output         EMIOENET0PTPDELAYREQTX,
  output         EMIOENET0PTPPDELAYREQRX,
  output         EMIOENET0PTPPDELAYREQTX,
  output         EMIOENET0PTPPDELAYRESPRX,
  output         EMIOENET0PTPPDELAYRESPTX,
  output         EMIOENET0PTPSYNCFRAMERX,
  output         EMIOENET0PTPSYNCFRAMETX,
  output         EMIOENET0SOFRX,
  output         EMIOENET0SOFTX,
  input          EMIOENET1EXTINTIN,
  input          EMIOENET1GMIICOL,
  input          EMIOENET1GMIICRS,
  input          EMIOENET1GMIIRXCLK,
  input  [ 7: 0] EMIOENET1GMIIRXD,
  input          EMIOENET1GMIIRXDV,
  input          EMIOENET1GMIIRXER,
  input          EMIOENET1GMIITXCLK,
  output [ 7: 0] EMIOENET1GMIITXD,
  output         EMIOENET1GMIITXEN,
  output         EMIOENET1GMIITXER,
  input          EMIOENET1MDIOI,
  output         EMIOENET1MDIOMDC,
  output         EMIOENET1MDIOO,
  output         EMIOENET1MDIOTN,
  output         EMIOENET1PTPDELAYREQRX,
  output         EMIOENET1PTPDELAYREQTX,
  output         EMIOENET1PTPPDELAYREQRX,
  output         EMIOENET1PTPPDELAYREQTX,
  output         EMIOENET1PTPPDELAYRESPRX,
  output         EMIOENET1PTPPDELAYRESPTX,
  output         EMIOENET1PTPSYNCFRAMERX,
  output         EMIOENET1PTPSYNCFRAMETX,
  output         EMIOENET1SOFRX,
  output         EMIOENET1SOFTX,
  input  [63: 0] EMIOGPIOI,
  output [63: 0] EMIOGPIOO,
  output [63: 0] EMIOGPIOTN,
  input          EMIOI2C0SCLI,
  output         EMIOI2C0SCLO,
  output         EMIOI2C0SCLTN,
  input          EMIOI2C0SDAI,
  output         EMIOI2C0SDAO,
  output         EMIOI2C0SDATN,
  input          EMIOI2C1SCLI,
  output         EMIOI2C1SCLO,
  output         EMIOI2C1SCLTN,
  input          EMIOI2C1SDAI,
  output         EMIOI2C1SDAO,
  output         EMIOI2C1SDATN,
  input          EMIOPJTAGTCK,
  input          EMIOPJTAGTDI,
  output         EMIOPJTAGTDO,
  output         EMIOPJTAGTDTN,
  input          EMIOPJTAGTMS,
  output         EMIOSDIO0BUSPOW,
  output [ 2: 0] EMIOSDIO0BUSVOLT,
  input          EMIOSDIO0CDN,
  output         EMIOSDIO0CLK,
  input          EMIOSDIO0CLKFB,
  input          EMIOSDIO0CMDI,
  output         EMIOSDIO0CMDO,
  output         EMIOSDIO0CMDTN,
  input  [ 3: 0] EMIOSDIO0DATAI,
  output [ 3: 0] EMIOSDIO0DATAO,
  output [ 3: 0] EMIOSDIO0DATATN,
  output         EMIOSDIO0LED,
  input          EMIOSDIO0WP,
  output         EMIOSDIO1BUSPOW,
  output [ 2: 0] EMIOSDIO1BUSVOLT,
  input          EMIOSDIO1CDN,
  output         EMIOSDIO1CLK,
  input          EMIOSDIO1CLKFB,
  input          EMIOSDIO1CMDI,
  output         EMIOSDIO1CMDO,
  output         EMIOSDIO1CMDTN,
  input  [ 3: 0] EMIOSDIO1DATAI,
  output [ 3: 0] EMIOSDIO1DATAO,
  output [ 3: 0] EMIOSDIO1DATATN,
  output         EMIOSDIO1LED,
  input          EMIOSDIO1WP,
  input          EMIOSPI0MI,
  output         EMIOSPI0MO,
  output         EMIOSPI0MOTN,
  input          EMIOSPI0SCLKI,
  output         EMIOSPI0SCLKO,
  output         EMIOSPI0SCLKTN,
  input          EMIOSPI0SI,
  output         EMIOSPI0SO,
  input          EMIOSPI0SSIN,
  output         EMIOSPI0SSNTN,
  output [ 2: 0] EMIOSPI0SSON,
  output         EMIOSPI0STN,
  input          EMIOSPI1MI,
  output         EMIOSPI1MO,
  output         EMIOSPI1MOTN,
  input          EMIOSPI1SCLKI,
  output         EMIOSPI1SCLKO,
  output         EMIOSPI1SCLKTN,
  input          EMIOSPI1SI,
  output         EMIOSPI1SO,
  input          EMIOSPI1SSIN,
  output         EMIOSPI1SSNTN,
  output [ 2: 0] EMIOSPI1SSON,
  output         EMIOSPI1STN,
  input          EMIOSRAMINTIN,
  input          EMIOTRACECLK,
  output         EMIOTRACECTL,
  output [31: 0] EMIOTRACEDATA,
  input  [ 2: 0] EMIOTTC0CLKI,
  output [ 2: 0] EMIOTTC0WAVEO,
  input  [ 2: 0] EMIOTTC1CLKI,
  output [ 2: 0] EMIOTTC1WAVEO,
  input          EMIOUART0CTSN,
  input          EMIOUART0DCDN,
  input          EMIOUART0DSRN,
  output         EMIOUART0DTRN,
  input          EMIOUART0RIN,
  output         EMIOUART0RTSN,
  input          EMIOUART0RX,
  output         EMIOUART0TX,
  input          EMIOUART1CTSN,
  input          EMIOUART1DCDN,
  input          EMIOUART1DSRN,
  output         EMIOUART1DTRN,
  input          EMIOUART1RIN,
  output         EMIOUART1RTSN,
  input          EMIOUART1RX,
  output         EMIOUART1TX,
  output [ 1: 0] EMIOUSB0PORTINDCTL,
  input          EMIOUSB0VBUSPWRFAULT,
  output         EMIOUSB0VBUSPWRSELECT,
  output [ 1: 0] EMIOUSB1PORTINDCTL,
  input          EMIOUSB1VBUSPWRFAULT,
  output         EMIOUSB1VBUSPWRSELECT,
  input          EMIOWDTCLKI,
  output         EMIOWDTRSTO,
  input          EVENTEVENTI,
  output         EVENTEVENTO,
  output [ 1: 0] EVENTSTANDBYWFE,
  output [ 1: 0] EVENTSTANDBYWFI,
  output [ 3: 0] FCLKCLK,
  input  [ 3: 0] FCLKCLKTRIGN,
  output [ 3: 0] FCLKRESETN,
  input          FPGAIDLEN,
  input  [ 3: 0] FTMDTRACEINATID,
  input          FTMDTRACEINCLOCK,
  input  [31: 0] FTMDTRACEINDATA,
  input          FTMDTRACEINVALID,
  input  [31: 0] FTMTF2PDEBUG,
  input  [ 3: 0] FTMTF2PTRIG,
  output [ 3: 0] FTMTF2PTRIGACK,
  output [31: 0] FTMTP2FDEBUG,
  output [ 3: 0] FTMTP2FTRIG,
  input  [ 3: 0] FTMTP2FTRIGACK,
  input  [19: 0] IRQF2P,
  output [28: 0] IRQP2F,
  input          MAXIGP0ACLK,
  output [31: 0] MAXIGP0ARADDR,
  output [ 1: 0] MAXIGP0ARBURST,
  output [ 3: 0] MAXIGP0ARCACHE,
  output         MAXIGP0ARESETN,
  output [11: 0] MAXIGP0ARID,
  output [ 3: 0] MAXIGP0ARLEN,
  output [ 1: 0] MAXIGP0ARLOCK,
  output [ 2: 0] MAXIGP0ARPROT,
  output [ 3: 0] MAXIGP0ARQOS,
  input          MAXIGP0ARREADY,
  output [ 1: 0] MAXIGP0ARSIZE,
  output         MAXIGP0ARVALID,
  output [31: 0] MAXIGP0AWADDR,
  output [ 1: 0] MAXIGP0AWBURST,
  output [ 3: 0] MAXIGP0AWCACHE,
  output [11: 0] MAXIGP0AWID,
  output [ 3: 0] MAXIGP0AWLEN,
  output [ 1: 0] MAXIGP0AWLOCK,
  output [ 2: 0] MAXIGP0AWPROT,
  output [ 3: 0] MAXIGP0AWQOS,
  input          MAXIGP0AWREADY,
  output [ 1: 0] MAXIGP0AWSIZE,
  output         MAXIGP0AWVALID,
  input  [11: 0] MAXIGP0BID,
  output         MAXIGP0BREADY,
  input  [ 1: 0] MAXIGP0BRESP,
  input          MAXIGP0BVALID,
  input  [31: 0] MAXIGP0RDATA,
  input  [11: 0] MAXIGP0RID,
  input          MAXIGP0RLAST,
  output         MAXIGP0RREADY,
  input  [ 1: 0] MAXIGP0RRESP,
  input          MAXIGP0RVALID,
  output [31: 0] MAXIGP0WDATA,
  output [11: 0] MAXIGP0WID,
  output         MAXIGP0WLAST,
  input          MAXIGP0WREADY,
  output [ 3: 0] MAXIGP0WSTRB,
  output         MAXIGP0WVALID,
  input          MAXIGP1ACLK,
  output [31: 0] MAXIGP1ARADDR,
  output [ 1: 0] MAXIGP1ARBURST,
  output [ 3: 0] MAXIGP1ARCACHE,
  output         MAXIGP1ARESETN,
  output [11: 0] MAXIGP1ARID,
  output [ 3: 0] MAXIGP1ARLEN,
  output [ 1: 0] MAXIGP1ARLOCK,
  output [ 2: 0] MAXIGP1ARPROT,
  output [ 3: 0] MAXIGP1ARQOS,
  input          MAXIGP1ARREADY,
  output [ 1: 0] MAXIGP1ARSIZE,
  output         MAXIGP1ARVALID,
  output [31: 0] MAXIGP1AWADDR,
  output [ 1: 0] MAXIGP1AWBURST,
  output [ 3: 0] MAXIGP1AWCACHE,
  output [11: 0] MAXIGP1AWID,
  output [ 3: 0] MAXIGP1AWLEN,
  output [ 1: 0] MAXIGP1AWLOCK,
  output [ 2: 0] MAXIGP1AWPROT,
  output [ 3: 0] MAXIGP1AWQOS,
  input          MAXIGP1AWREADY,
  output [ 1: 0] MAXIGP1AWSIZE,
  output         MAXIGP1AWVALID,
  input  [11: 0] MAXIGP1BID,
  output         MAXIGP1BREADY,
  input  [ 1: 0] MAXIGP1BRESP,
  input          MAXIGP1BVALID,
  input  [31: 0] MAXIGP1RDATA,
  input  [11: 0] MAXIGP1RID,
  input          MAXIGP1RLAST,
  output         MAXIGP1RREADY,
  input  [ 1: 0] MAXIGP1RRESP,
  input          MAXIGP1RVALID,
  output [31: 0] MAXIGP1WDATA,
  output [11: 0] MAXIGP1WID,
  output         MAXIGP1WLAST,
  input          MAXIGP1WREADY,
  output [ 3: 0] MAXIGP1WSTRB,
  output         MAXIGP1WVALID,
  input          SAXIACPACLK,
  input  [31: 0] SAXIACPARADDR,
  input  [ 1: 0] SAXIACPARBURST,
  input  [ 3: 0] SAXIACPARCACHE,
  output         SAXIACPARESETN,
  input  [ 2: 0] SAXIACPARID,
  input  [ 3: 0] SAXIACPARLEN,
  input  [ 1: 0] SAXIACPARLOCK,
  input  [ 2: 0] SAXIACPARPROT,
  input  [ 3: 0] SAXIACPARQOS,
  output         SAXIACPARREADY,
  input  [ 1: 0] SAXIACPARSIZE,
  input  [ 4: 0] SAXIACPARUSER,
  input          SAXIACPARVALID,
  input  [31: 0] SAXIACPAWADDR,
  input  [ 1: 0] SAXIACPAWBURST,
  input  [ 3: 0] SAXIACPAWCACHE,
  input  [ 2: 0] SAXIACPAWID,
  input  [ 3: 0] SAXIACPAWLEN,
  input  [ 1: 0] SAXIACPAWLOCK,
  input  [ 2: 0] SAXIACPAWPROT,
  input  [ 3: 0] SAXIACPAWQOS,
  output         SAXIACPAWREADY,
  input  [ 1: 0] SAXIACPAWSIZE,
  input  [ 4: 0] SAXIACPAWUSER,
  input          SAXIACPAWVALID,
  output [ 2: 0] SAXIACPBID,
  input          SAXIACPBREADY,
  output [ 1: 0] SAXIACPBRESP,
  output         SAXIACPBVALID,
  output [63: 0] SAXIACPRDATA,
  output [ 2: 0] SAXIACPRID,
  output         SAXIACPRLAST,
  input          SAXIACPRREADY,
  output [ 1: 0] SAXIACPRRESP,
  output         SAXIACPRVALID,
  input  [63: 0] SAXIACPWDATA,
  input  [ 2: 0] SAXIACPWID,
  input          SAXIACPWLAST,
  output         SAXIACPWREADY,
  input  [ 7: 0] SAXIACPWSTRB,
  input          SAXIACPWVALID,
  input          SAXIGP0ACLK,
  input  [31: 0] SAXIGP0ARADDR,
  input  [ 1: 0] SAXIGP0ARBURST,
  input  [ 3: 0] SAXIGP0ARCACHE,
  output         SAXIGP0ARESETN,
  input  [ 5: 0] SAXIGP0ARID,
  input  [ 3: 0] SAXIGP0ARLEN,
  input  [ 1: 0] SAXIGP0ARLOCK,
  input  [ 2: 0] SAXIGP0ARPROT,
  input  [ 3: 0] SAXIGP0ARQOS,
  output         SAXIGP0ARREADY,
  input  [ 1: 0] SAXIGP0ARSIZE,
  input          SAXIGP0ARVALID,
  input  [31: 0] SAXIGP0AWADDR,
  input  [ 1: 0] SAXIGP0AWBURST,
  input  [ 3: 0] SAXIGP0AWCACHE,
  input  [ 5: 0] SAXIGP0AWID,
  input  [ 3: 0] SAXIGP0AWLEN,
  input  [ 1: 0] SAXIGP0AWLOCK,
  input  [ 2: 0] SAXIGP0AWPROT,
  input  [ 3: 0] SAXIGP0AWQOS,
  output         SAXIGP0AWREADY,
  input  [ 1: 0] SAXIGP0AWSIZE,
  input          SAXIGP0AWVALID,
  output [ 5: 0] SAXIGP0BID,
  input          SAXIGP0BREADY,
  output [ 1: 0] SAXIGP0BRESP,
  output         SAXIGP0BVALID,
  output [31: 0] SAXIGP0RDATA,
  output [ 5: 0] SAXIGP0RID,
  output         SAXIGP0RLAST,
  input          SAXIGP0RREADY,
  output [ 1: 0] SAXIGP0RRESP,
  output         SAXIGP0RVALID,
  input  [31: 0] SAXIGP0WDATA,
  input  [ 5: 0] SAXIGP0WID,
  input          SAXIGP0WLAST,
  output         SAXIGP0WREADY,
  input  [ 3: 0] SAXIGP0WSTRB,
  input          SAXIGP0WVALID,
  input          SAXIGP1ACLK,
  input  [31: 0] SAXIGP1ARADDR,
  input  [ 1: 0] SAXIGP1ARBURST,
  input  [ 3: 0] SAXIGP1ARCACHE,
  output         SAXIGP1ARESETN,
  input  [ 5: 0] SAXIGP1ARID,
  input  [ 3: 0] SAXIGP1ARLEN,
  input  [ 1: 0] SAXIGP1ARLOCK,
  input  [ 2: 0] SAXIGP1ARPROT,
  input  [ 3: 0] SAXIGP1ARQOS,
  output         SAXIGP1ARREADY,
  input  [ 1: 0] SAXIGP1ARSIZE,
  input          SAXIGP1ARVALID,
  input  [31: 0] SAXIGP1AWADDR,
  input  [ 1: 0] SAXIGP1AWBURST,
  input  [ 3: 0] SAXIGP1AWCACHE,
  input  [ 5: 0] SAXIGP1AWID,
  input  [ 3: 0] SAXIGP1AWLEN,
  input  [ 1: 0] SAXIGP1AWLOCK,
  input  [ 2: 0] SAXIGP1AWPROT,
  input  [ 3: 0] SAXIGP1AWQOS,
  output         SAXIGP1AWREADY,
  input  [ 1: 0] SAXIGP1AWSIZE,
  input          SAXIGP1AWVALID,
  output [ 5: 0] SAXIGP1BID,
  input          SAXIGP1BREADY,
  output [ 1: 0] SAXIGP1BRESP,
  output         SAXIGP1BVALID,
  output [31: 0] SAXIGP1RDATA,
  output [ 5: 0] SAXIGP1RID,
  output         SAXIGP1RLAST,
  input          SAXIGP1RREADY,
  output [ 1: 0] SAXIGP1RRESP,
  output         SAXIGP1RVALID,
  input  [31: 0] SAXIGP1WDATA,
  input  [ 5: 0] SAXIGP1WID,
  input          SAXIGP1WLAST,
  output         SAXIGP1WREADY,
  input  [ 3: 0] SAXIGP1WSTRB,
  input          SAXIGP1WVALID,
  input          SAXIHP0ACLK,
  input  [31: 0] SAXIHP0ARADDR,
  input  [ 1: 0] SAXIHP0ARBURST,
  input  [ 3: 0] SAXIHP0ARCACHE,
  output         SAXIHP0ARESETN,
  input  [ 5: 0] SAXIHP0ARID,
  input  [ 3: 0] SAXIHP0ARLEN,
  input  [ 1: 0] SAXIHP0ARLOCK,
  input  [ 2: 0] SAXIHP0ARPROT,
  input  [ 3: 0] SAXIHP0ARQOS,
  output         SAXIHP0ARREADY,
  input  [ 1: 0] SAXIHP0ARSIZE,
  input          SAXIHP0ARVALID,
  input  [31: 0] SAXIHP0AWADDR,
  input  [ 1: 0] SAXIHP0AWBURST,
  input  [ 3: 0] SAXIHP0AWCACHE,
  input  [ 5: 0] SAXIHP0AWID,
  input  [ 3: 0] SAXIHP0AWLEN,
  input  [ 1: 0] SAXIHP0AWLOCK,
  input  [ 2: 0] SAXIHP0AWPROT,
  input  [ 3: 0] SAXIHP0AWQOS,
  output         SAXIHP0AWREADY,
  input  [ 1: 0] SAXIHP0AWSIZE,
  input          SAXIHP0AWVALID,
  output [ 5: 0] SAXIHP0BID,
  input          SAXIHP0BREADY,
  output [ 1: 0] SAXIHP0BRESP,
  output         SAXIHP0BVALID,
  output [ 2: 0] SAXIHP0RACOUNT,
  output [ 7: 0] SAXIHP0RCOUNT,
  output [63: 0] SAXIHP0RDATA,
  input          SAXIHP0RDISSUECAP1EN,
  output [ 5: 0] SAXIHP0RID,
  output         SAXIHP0RLAST,
  input          SAXIHP0RREADY,
  output [ 1: 0] SAXIHP0RRESP,
  output         SAXIHP0RVALID,
  output [ 5: 0] SAXIHP0WACOUNT,
  output [ 7: 0] SAXIHP0WCOUNT,
  input  [63: 0] SAXIHP0WDATA,
  input  [ 5: 0] SAXIHP0WID,
  input          SAXIHP0WLAST,
  output         SAXIHP0WREADY,
  input          SAXIHP0WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP0WSTRB,
  input          SAXIHP0WVALID,
  input          SAXIHP1ACLK,
  input  [31: 0] SAXIHP1ARADDR,
  input  [ 1: 0] SAXIHP1ARBURST,
  input  [ 3: 0] SAXIHP1ARCACHE,
  output         SAXIHP1ARESETN,
  input  [ 5: 0] SAXIHP1ARID,
  input  [ 3: 0] SAXIHP1ARLEN,
  input  [ 1: 0] SAXIHP1ARLOCK,
  input  [ 2: 0] SAXIHP1ARPROT,
  input  [ 3: 0] SAXIHP1ARQOS,
  output         SAXIHP1ARREADY,
  input  [ 1: 0] SAXIHP1ARSIZE,
  input          SAXIHP1ARVALID,
  input  [31: 0] SAXIHP1AWADDR,
  input  [ 1: 0] SAXIHP1AWBURST,
  input  [ 3: 0] SAXIHP1AWCACHE,
  input  [ 5: 0] SAXIHP1AWID,
  input  [ 3: 0] SAXIHP1AWLEN,
  input  [ 1: 0] SAXIHP1AWLOCK,
  input  [ 2: 0] SAXIHP1AWPROT,
  input  [ 3: 0] SAXIHP1AWQOS,
  output         SAXIHP1AWREADY,
  input  [ 1: 0] SAXIHP1AWSIZE,
  input          SAXIHP1AWVALID,
  output [ 5: 0] SAXIHP1BID,
  input          SAXIHP1BREADY,
  output [ 1: 0] SAXIHP1BRESP,
  output         SAXIHP1BVALID,
  output [ 2: 0] SAXIHP1RACOUNT,
  output [ 7: 0] SAXIHP1RCOUNT,
  output [63: 0] SAXIHP1RDATA,
  input          SAXIHP1RDISSUECAP1EN,
  output [ 5: 0] SAXIHP1RID,
  output         SAXIHP1RLAST,
  input          SAXIHP1RREADY,
  output [ 1: 0] SAXIHP1RRESP,
  output         SAXIHP1RVALID,
  output [ 5: 0] SAXIHP1WACOUNT,
  output [ 7: 0] SAXIHP1WCOUNT,
  input  [63: 0] SAXIHP1WDATA,
  input  [ 5: 0] SAXIHP1WID,
  input          SAXIHP1WLAST,
  output         SAXIHP1WREADY,
  input          SAXIHP1WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP1WSTRB,
  input          SAXIHP1WVALID,
  input          SAXIHP2ACLK,
  input  [31: 0] SAXIHP2ARADDR,
  input  [ 1: 0] SAXIHP2ARBURST,
  input  [ 3: 0] SAXIHP2ARCACHE,
  output         SAXIHP2ARESETN,
  input  [ 5: 0] SAXIHP2ARID,
  input  [ 3: 0] SAXIHP2ARLEN,
  input  [ 1: 0] SAXIHP2ARLOCK,
  input  [ 2: 0] SAXIHP2ARPROT,
  input  [ 3: 0] SAXIHP2ARQOS,
  output         SAXIHP2ARREADY,
  input  [ 1: 0] SAXIHP2ARSIZE,
  input          SAXIHP2ARVALID,
  input  [31: 0] SAXIHP2AWADDR,
  input  [ 1: 0] SAXIHP2AWBURST,
  input  [ 3: 0] SAXIHP2AWCACHE,
  input  [ 5: 0] SAXIHP2AWID,
  input  [ 3: 0] SAXIHP2AWLEN,
  input  [ 1: 0] SAXIHP2AWLOCK,
  input  [ 2: 0] SAXIHP2AWPROT,
  input  [ 3: 0] SAXIHP2AWQOS,
  output         SAXIHP2AWREADY,
  input  [ 1: 0] SAXIHP2AWSIZE,
  input          SAXIHP2AWVALID,
  output [ 5: 0] SAXIHP2BID,
  input          SAXIHP2BREADY,
  output [ 1: 0] SAXIHP2BRESP,
  output         SAXIHP2BVALID,
  output [ 2: 0] SAXIHP2RACOUNT,
  output [ 7: 0] SAXIHP2RCOUNT,
  output [63: 0] SAXIHP2RDATA,
  input          SAXIHP2RDISSUECAP1EN,
  output [ 5: 0] SAXIHP2RID,
  output         SAXIHP2RLAST,
  input          SAXIHP2RREADY,
  output [ 1: 0] SAXIHP2RRESP,
  output         SAXIHP2RVALID,
  output [ 5: 0] SAXIHP2WACOUNT,
  output [ 7: 0] SAXIHP2WCOUNT,
  input  [63: 0] SAXIHP2WDATA,
  input  [ 5: 0] SAXIHP2WID,
  input          SAXIHP2WLAST,
  output         SAXIHP2WREADY,
  input          SAXIHP2WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP2WSTRB,
  input          SAXIHP2WVALID,
  input          SAXIHP3ACLK,
  input  [31: 0] SAXIHP3ARADDR,
  input  [ 1: 0] SAXIHP3ARBURST,
  input  [ 3: 0] SAXIHP3ARCACHE,
  output         SAXIHP3ARESETN,
  input  [ 5: 0] SAXIHP3ARID,
  input  [ 3: 0] SAXIHP3ARLEN,
  input  [ 1: 0] SAXIHP3ARLOCK,
  input  [ 2: 0] SAXIHP3ARPROT,
  input  [ 3: 0] SAXIHP3ARQOS,
  output         SAXIHP3ARREADY,
  input  [ 1: 0] SAXIHP3ARSIZE,
  input          SAXIHP3ARVALID,
  input  [31: 0] SAXIHP3AWADDR,
  input  [ 1: 0] SAXIHP3AWBURST,
  input  [ 3: 0] SAXIHP3AWCACHE,
  input  [ 5: 0] SAXIHP3AWID,
  input  [ 3: 0] SAXIHP3AWLEN,
  input  [ 1: 0] SAXIHP3AWLOCK,
  input  [ 2: 0] SAXIHP3AWPROT,
  input  [ 3: 0] SAXIHP3AWQOS,
  output         SAXIHP3AWREADY,
  input  [ 1: 0] SAXIHP3AWSIZE,
  input          SAXIHP3AWVALID,
  output [ 5: 0] SAXIHP3BID,
  input          SAXIHP3BREADY,
  output [ 1: 0] SAXIHP3BRESP,
  output         SAXIHP3BVALID,
  output [ 2: 0] SAXIHP3RACOUNT,
  output [ 7: 0] SAXIHP3RCOUNT,
  output [63: 0] SAXIHP3RDATA,
  input          SAXIHP3RDISSUECAP1EN,
  output [ 5: 0] SAXIHP3RID,
  output         SAXIHP3RLAST,
  input          SAXIHP3RREADY,
  output [ 1: 0] SAXIHP3RRESP,
  output         SAXIHP3RVALID,
  output [ 5: 0] SAXIHP3WACOUNT,
  output [ 7: 0] SAXIHP3WCOUNT,
  input  [63: 0] SAXIHP3WDATA,
  input  [ 5: 0] SAXIHP3WID,
  input          SAXIHP3WLAST,
  output         SAXIHP3WREADY,
  input          SAXIHP3WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP3WSTRB,
  input          SAXIHP3WVALID
);

endmodule

module BANK();

parameter KEEP = 1;
parameter DONT_TOUCH = 1;
parameter FASM_EXTRA = "";
parameter INTERNAL_VREF = "";
parameter NUMBER = "";

endmodule

module IPAD_GTP_VPR (
  input I,
  output O
  );

  assign O = I;
endmodule

module OPAD_GTP_VPR (
  input I,
  output O
  );

  assign O = I;
endmodule

module IBUFDS_GTE2_VPR (
  output O,
  output ODIV2,
  input CEB,
  input I,
  input IB
  );

  parameter CLKCM_CFG = 1'b1;
  parameter CLKRCV_TRST = 1'b1;
endmodule

module GTPE2_COMMON_VPR (
  output DRPRDY,
  output PLL0FBCLKLOST,
  output PLL0LOCK,
  output PLL0OUTCLK,
  output PLL0OUTREFCLK,
  output PLL0REFCLKLOST,
  output PLL1FBCLKLOST,
  output PLL1LOCK,
  output PLL1OUTCLK,
  output PLL1OUTREFCLK,
  output PLL1REFCLKLOST,
  output REFCLKOUTMONITOR0,
  output REFCLKOUTMONITOR1,
  output [15:0] DRPDO,
  output [15:0] PMARSVDOUT,
  output [7:0] DMONITOROUT,
  input BGBYPASSB,
  input BGMONITORENB,
  input BGPDB,
  input BGRCALOVRDENB,
  input DRPCLK,
  input DRPEN,
  input DRPWE,
  input GTREFCLK0,
  input GTREFCLK1,
  input GTGREFCLK0,
  input GTGREFCLK1,
  input PLL0LOCKDETCLK,
  input PLL0LOCKEN,
  input PLL0PD,
  input PLL0RESET,
  input PLL1LOCKDETCLK,
  input PLL1LOCKEN,
  input PLL1PD,
  input PLL1RESET,
  input RCALENB,
  input [15:0] DRPDI,
  input [2:0] PLL0REFCLKSEL,
  input [2:0] PLL1REFCLKSEL,
  input [4:0] BGRCALOVRD,
  input [7:0] DRPADDR,
  input [7:0] PMARSVD
);
  parameter [63:0] BIAS_CFG = 64'h0000000000000000;
  parameter [31:0] COMMON_CFG = 32'h00000000;
  parameter [26:0] PLL0_CFG = 27'h01F03DC;
  parameter [0:0] PLL0_DMON_CFG = 1'b0;
  parameter [5:0] PLL0_FBDIV = 6'b000010;
  parameter PLL0_FBDIV_45 = 1'b1;
  parameter [23:0] PLL0_INIT_CFG = 24'h00001E;
  parameter [8:0] PLL0_LOCK_CFG = 9'h1E8;
  parameter [4:0] PLL0_REFCLK_DIV = 5'b10000;
  parameter [26:0] PLL1_CFG = 27'h01F03DC;
  parameter [0:0] PLL1_DMON_CFG = 1'b0;
  parameter [5:0] PLL1_FBDIV = 6'b000010;
  parameter PLL1_FBDIV_45 = 1'b1;
  parameter [23:0] PLL1_INIT_CFG = 24'h00001E;
  parameter [8:0] PLL1_LOCK_CFG = 9'h1E8;
  parameter [4:0] PLL1_REFCLK_DIV = 5'b10000;
  parameter [7:0] PLL_CLKOUT_CFG = 8'b00000000;
  parameter [15:0] RSVD_ATTR0 = 16'h0000;
  parameter [15:0] RSVD_ATTR1 = 16'h0000;
  parameter INV_DRPCLK = 1'b0;
  parameter INV_PLL1LOCKDETCLK = 1'b0;
  parameter INV_PLL0LOCKDETCLK = 1'b0;
  parameter GTREFCLK0_USED = 1'b0;
  parameter GTREFCLK1_USED = 1'b0;
  parameter BOTH_GTREFCLK_USED = 1'b0;
  parameter ENABLE_DRP = 1'b1;

  // This parameter should never be changed according to UG482 (v1.9), pg 24
  parameter [1:0] IBUFDS_GTE2_CLKSWING_CFG = 2'b11;

endmodule

module GTPE2_CHANNEL_VPR (
  input GTPRXN,
  input GTPRXP,
  output GTPTXN,
  output GTPTXP,
  output DRPRDY,
  output EYESCANDATAERROR,
  output PHYSTATUS,
  output PMARSVDOUT0,
  output PMARSVDOUT1,
  output RXBYTEISALIGNED,
  output RXBYTEREALIGN,
  output RXCDRLOCK,
  output RXCHANBONDSEQ,
  output RXCHANISALIGNED,
  output RXCHANREALIGN,
  output RXCOMINITDET,
  output RXCOMMADET,
  output RXCOMSASDET,
  output RXCOMWAKEDET,
  output RXDLYSRESETDONE,
  output RXELECIDLE,
  output RXHEADERVALID,
  output RXOSINTDONE,
  output RXOSINTSTARTED,
  output RXOSINTSTROBEDONE,
  output RXOSINTSTROBESTARTED,
  output RXOUTCLK,
  output RXOUTCLKFABRIC,
  output RXOUTCLKPCS,
  output RXPHALIGNDONE,
  output RXPMARESETDONE,
  output RXPRBSERR,
  output RXRATEDONE,
  output RXRESETDONE,
  output RXSYNCDONE,
  output RXSYNCOUT,
  output RXVALID,
  output TXCOMFINISH,
  output TXDLYSRESETDONE,
  output TXGEARBOXREADY,
  output TXOUTCLK,
  output TXOUTCLKFABRIC,
  output TXOUTCLKPCS,
  output TXPHALIGNDONE,
  output TXPHINITDONE,
  output TXPMARESETDONE,
  output TXRATEDONE,
  output TXRESETDONE,
  output TXSYNCDONE,
  output TXSYNCOUT,
  output [14:0] DMONITOROUT,
  output [15:0] DRPDO,
  output [15:0] PCSRSVDOUT,
  output [1:0] RXCLKCORCNT,
  output [1:0] RXDATAVALID,
  output [1:0] RXSTARTOFSEQ,
  output [1:0] TXBUFSTATUS,
  output [2:0] RXBUFSTATUS,
  output [2:0] RXHEADER,
  output [2:0] RXSTATUS,
  output [31:0] RXDATA,
  output [3:0] RXCHARISCOMMA,
  output [3:0] RXCHARISK,
  output [3:0] RXCHBONDO,
  output [3:0] RXDISPERR,
  output [3:0] RXNOTINTABLE,
  output [4:0] RXPHMONITOR,
  output [4:0] RXPHSLIPMONITOR,
  input CFGRESET,
  input CLKRSVD0,
  input CLKRSVD1,
  input DMONFIFORESET,
  input DMONITORCLK,
  input DRPCLK,
  input DRPEN,
  input DRPWE,
  input EYESCANMODE,
  input EYESCANRESET,
  input EYESCANTRIGGER,
  input GTRESETSEL,
  input GTRXRESET,
  input GTTXRESET,
  input PMARSVDIN0,
  input PMARSVDIN1,
  input PMARSVDIN2,
  input PMARSVDIN3,
  input PMARSVDIN4,
  input RESETOVRD,
  input RX8B10BEN,
  input RXBUFRESET,
  input RXCDRFREQRESET,
  input RXCDRHOLD,
  input RXCDROVRDEN,
  input RXCDRRESET,
  input RXCDRRESETRSV,
  input RXCHBONDEN,
  input RXCHBONDMASTER,
  input RXCHBONDSLAVE,
  input RXCOMMADETEN,
  input RXDDIEN,
  input RXDFEXYDEN,
  input RXDLYBYPASS,
  input RXDLYEN,
  input RXDLYOVRDEN,
  input RXDLYSRESET,
  input RXGEARBOXSLIP,
  input RXLPMHFHOLD,
  input RXLPMHFOVRDEN,
  input RXLPMLFHOLD,
  input RXLPMLFOVRDEN,
  input RXLPMOSINTNTRLEN,
  input RXLPMRESET,
  input RXMCOMMAALIGNEN,
  input RXOOBRESET,
  input RXOSCALRESET,
  input RXOSHOLD,
  input RXOSINTEN,
  input RXOSINTHOLD,
  input RXOSINTNTRLEN,
  input RXOSINTOVRDEN,
  input RXOSINTPD,
  input RXOSINTSTROBE,
  input RXOSINTTESTOVRDEN,
  input RXOSOVRDEN,
  input RXPCOMMAALIGNEN,
  input RXPCSRESET,
  input RXPHALIGN,
  input RXPHALIGNEN,
  input RXPHDLYPD,
  input RXPHDLYRESET,
  input RXPHOVRDEN,
  input RXPMARESET,
  input RXPOLARITY,
  input RXPRBSCNTRESET,
  input RXRATEMODE,
  input RXSLIDE,
  input RXSYNCALLIN,
  input RXSYNCIN,
  input RXSYNCMODE,
  input RXUSERRDY,
  input RXUSRCLK2,
  input RXUSRCLK,
  input SETERRSTATUS,
  input SIGVALIDCLK,
  input TX8B10BEN,
  input TXCOMINIT,
  input TXCOMSAS,
  input TXCOMWAKE,
  input TXDEEMPH,
  input TXDETECTRX,
  input TXDIFFPD,
  input TXDLYBYPASS,
  input TXDLYEN,
  input TXDLYHOLD,
  input TXDLYOVRDEN,
  input TXDLYSRESET,
  input TXDLYUPDOWN,
  input TXELECIDLE,
  input TXINHIBIT,
  input TXPCSRESET,
  input TXPDELECIDLEMODE,
  input TXPHALIGN,
  input TXPHALIGNEN,
  input TXPHDLYPD,
  input TXPHDLYRESET,
  input TXPHDLYTSTCLK,
  input TXPHINIT,
  input TXPHOVRDEN,
  input TXPIPPMEN,
  input TXPIPPMOVRDEN,
  input TXPIPPMPD,
  input TXPIPPMSEL,
  input TXPISOPD,
  input TXPMARESET,
  input TXPOLARITY,
  input TXPOSTCURSORINV,
  input TXPRBSFORCEERR,
  input TXPRECURSORINV,
  input TXRATEMODE,
  input TXSTARTSEQ,
  input TXSWING,
  input TXSYNCALLIN,
  input TXSYNCIN,
  input TXSYNCMODE,
  input TXUSERRDY,
  input TXUSRCLK2,
  input TXUSRCLK,
  input [13:0] RXADAPTSELTEST,
  input [15:0] DRPDI,
  input [15:0] GTRSVD,
  input [15:0] PCSRSVDIN,
  input [19:0] TSTIN,
  input [1:0] RXELECIDLEMODE,
  input [1:0] RXPD,
  input [1:0] RXSYSCLKSEL,
  input [1:0] TXPD,
  input [1:0] TXSYSCLKSEL,
  input [2:0] LOOPBACK,
  input [2:0] RXCHBONDLEVEL,
  input [2:0] RXOUTCLKSEL,
  input [2:0] RXPRBSSEL,
  input [2:0] RXRATE,
  input [2:0] TXBUFDIFFCTRL,
  input [2:0] TXHEADER,
  input [2:0] TXMARGIN,
  input [2:0] TXOUTCLKSEL,
  input [2:0] TXPRBSSEL,
  input [2:0] TXRATE,
  input [31:0] TXDATA,
  input [3:0] RXCHBONDI,
  input [3:0] RXOSINTCFG,
  input [3:0] RXOSINTID0,
  input [3:0] TX8B10BBYPASS,
  input [3:0] TXCHARDISPMODE,
  input [3:0] TXCHARDISPVAL,
  input [3:0] TXCHARISK,
  input [3:0] TXDIFFCTRL,
  input [4:0] TXPIPPMSTEPSIZE,
  input [4:0] TXPOSTCURSOR,
  input [4:0] TXPRECURSOR,
  input [6:0] TXMAINCURSOR,
  input [6:0] TXSEQUENCE,
  input [8:0] DRPADDR
);
  parameter [0:0] ACJTAG_DEBUG_MODE = 1'b0;
  parameter [0:0] ACJTAG_MODE = 1'b0;
  parameter [0:0] ACJTAG_RESET = 1'b0;
  parameter [19:0] ADAPT_CFG0 = 20'b00000000000000000000;
  parameter ALIGN_COMMA_DOUBLE = 1'b0;
  parameter [9:0] ALIGN_COMMA_ENABLE = 10'b0001111111;
  parameter [1:0] ALIGN_COMMA_WORD = 1;
  parameter ALIGN_MCOMMA_DET = 1'b1;
  parameter [9:0] ALIGN_MCOMMA_VALUE = 10'b1010000011;
  parameter ALIGN_PCOMMA_DET = 1'b1;
  parameter [9:0] ALIGN_PCOMMA_VALUE = 10'b0101111100;
  parameter CBCC_DATA_SOURCE_SEL_DECODED = 1'b1;
  parameter [42:0] CFOK_CFG = 43'b1001001000000000000000001000000111010000000;
  parameter [6:0] CFOK_CFG2 = 7'b0100000;
  parameter [6:0] CFOK_CFG3 = 7'b0100000;
  parameter [0:0] CFOK_CFG4 = 1'b0;
  parameter [1:0] CFOK_CFG5 = 2'b00;
  parameter [3:0] CFOK_CFG6 = 4'b0000;
  parameter CHAN_BOND_KEEP_ALIGN = 1'b0;
  parameter [3:0] CHAN_BOND_MAX_SKEW = 7;
  parameter [9:0] CHAN_BOND_SEQ_1_1 = 10'b0101111100;
  parameter [9:0] CHAN_BOND_SEQ_1_2 = 10'b0000000000;
  parameter [9:0] CHAN_BOND_SEQ_1_3 = 10'b0000000000;
  parameter [9:0] CHAN_BOND_SEQ_1_4 = 10'b0000000000;
  parameter [3:0] CHAN_BOND_SEQ_1_ENABLE = 4'b1111;
  parameter [9:0] CHAN_BOND_SEQ_2_1 = 10'b0100000000;
  parameter [9:0] CHAN_BOND_SEQ_2_2 = 10'b0100000000;
  parameter [9:0] CHAN_BOND_SEQ_2_3 = 10'b0100000000;
  parameter [9:0] CHAN_BOND_SEQ_2_4 = 10'b0100000000;
  parameter [3:0] CHAN_BOND_SEQ_2_ENABLE = 4'b1111;
  parameter CHAN_BOND_SEQ_2_USE = 1'b0;
  parameter [1:0] CHAN_BOND_SEQ_LEN = 2'b00;
  parameter [0:0] CLK_COMMON_SWING = 1'b0;
  parameter CLK_CORRECT_USE = 1'b1;
  parameter CLK_COR_KEEP_IDLE = 1'b0;
  parameter [5:0] CLK_COR_MAX_LAT = 20;
  parameter [5:0] CLK_COR_MIN_LAT = 18;
  parameter CLK_COR_PRECEDENCE = 1'b1;
  parameter [4:0] CLK_COR_REPEAT_WAIT = 0;
  parameter [9:0] CLK_COR_SEQ_1_1 = 10'b0100011100;
  parameter [9:0] CLK_COR_SEQ_1_2 = 10'b0000000000;
  parameter [9:0] CLK_COR_SEQ_1_3 = 10'b0000000000;
  parameter [9:0] CLK_COR_SEQ_1_4 = 10'b0000000000;
  parameter [3:0] CLK_COR_SEQ_1_ENABLE = 4'b1111;
  parameter [9:0] CLK_COR_SEQ_2_1 = 10'b0100000000;
  parameter [9:0] CLK_COR_SEQ_2_2 = 10'b0100000000;
  parameter [9:0] CLK_COR_SEQ_2_3 = 10'b0100000000;
  parameter [9:0] CLK_COR_SEQ_2_4 = 10'b0100000000;
  parameter [3:0] CLK_COR_SEQ_2_ENABLE = 4'b1111;
  parameter CLK_COR_SEQ_2_USE = 1'b0;
  parameter [1:0] CLK_COR_SEQ_LEN = 2'b00;
  parameter DEC_MCOMMA_DETECT = 1'b1;
  parameter DEC_PCOMMA_DETECT = 1'b1;
  parameter DEC_VALID_COMMA_ONLY = 1'b1;
  parameter [23:0] DMONITOR_CFG = 24'h000A00;
  parameter [0:0] ES_CLK_PHASE_SEL = 1'b0;
  parameter [5:0] ES_CONTROL = 6'b000000;
  parameter ES_ERRDET_EN = 1'b0;
  parameter ES_EYE_SCAN_EN = 1'b0;
  parameter [11:0] ES_HORZ_OFFSET = 12'h010;
  parameter [9:0] ES_PMA_CFG = 10'b0000000000;
  parameter [4:0] ES_PRESCALE = 5'b00000;
  parameter [79:0] ES_QUALIFIER = 80'h00000000000000000000;
  parameter [79:0] ES_QUAL_MASK = 80'h00000000000000000000;
  parameter [79:0] ES_SDATA_MASK = 80'h00000000000000000000;
  parameter [8:0] ES_VERT_OFFSET = 9'b000000000;
  parameter [3:0] FTS_DESKEW_SEQ_ENABLE = 4'b1111;
  parameter [3:0] FTS_LANE_DESKEW_CFG = 4'b1111;
  parameter FTS_LANE_DESKEW_EN = 1'b0;
  parameter [2:0] GEARBOX_MODE = 3'b000;
  parameter [0:0] LOOPBACK_CFG = 1'b0;
  parameter [1:0] OUTREFCLK_SEL_INV = 2'b11;
  parameter PCS_PCIE_EN = 1'b0;
  parameter [47:0] PCS_RSVD_ATTR = 48'h000000000000;
  parameter [11:0] PD_TRANS_TIME_FROM_P2 = 12'h03C;
  parameter [7:0] PD_TRANS_TIME_NONE_P2 = 8'h19;
  parameter [7:0] PD_TRANS_TIME_TO_P2 = 8'h64;
  parameter [0:0] PMA_LOOPBACK_CFG = 1'b0;
  parameter [31:0] PMA_RSV = 32'h00000333;
  parameter [31:0] PMA_RSV2 = 32'h00002050;
  parameter [1:0] PMA_RSV3 = 2'b00;
  parameter [3:0] PMA_RSV4 = 4'b0000;
  parameter [0:0] PMA_RSV5 = 1'b0;
  parameter [0:0] PMA_RSV6 = 1'b0;
  parameter [0:0] PMA_RSV7 = 1'b0;
  parameter [4:0] RXBUFRESET_TIME = 5'b00001;
  parameter RXBUF_ADDR_MODE_FAST = 1'b0;
  parameter [3:0] RXBUF_EIDLE_HI_CNT = 4'b1000;
  parameter [3:0] RXBUF_EIDLE_LO_CNT = 4'b0000;
  parameter RXBUF_EN = 1'b1;
  parameter RXBUF_RESET_ON_CB_CHANGE = 1'b1;
  parameter RXBUF_RESET_ON_COMMAALIGN = 1'b0;
  parameter RXBUF_RESET_ON_EIDLE = 1'b0;
  parameter RXBUF_RESET_ON_RATE_CHANGE = 1'b1;
  parameter [5:0] RXBUF_THRESH_OVFLW = 61;
  parameter RXBUF_THRESH_OVRD = 1'b0;
  parameter [5:0] RXBUF_THRESH_UNDFLW = 4;
  parameter [4:0] RXCDRFREQRESET_TIME = 5'b00001;
  parameter [4:0] RXCDRPHRESET_TIME = 5'b00001;
  parameter [82:0] RXCDR_CFG = 83'h0000107FE406001041010;
  parameter [0:0] RXCDR_FR_RESET_ON_EIDLE = 1'b0;
  parameter [0:0] RXCDR_HOLD_DURING_EIDLE = 1'b0;
  parameter [5:0] RXCDR_LOCK_CFG = 6'b001001;
  parameter [0:0] RXCDR_PH_RESET_ON_EIDLE = 1'b0;
  parameter [15:0] RXDLY_CFG = 16'h0010;
  parameter [8:0] RXDLY_LCFG = 9'h020;
  parameter [15:0] RXDLY_TAP_CFG = 16'h0000;
  parameter RXGEARBOX_EN = 1'b0;
  parameter [4:0] RXISCANRESET_TIME = 5'b00001;
  parameter [6:0] RXLPMRESET_TIME = 7'b0001111;
  parameter [0:0] RXLPM_BIAS_STARTUP_DISABLE = 1'b0;
  parameter [3:0] RXLPM_CFG = 4'b0110;
  parameter [0:0] RXLPM_CFG1 = 1'b0;
  parameter [0:0] RXLPM_CM_CFG = 1'b0;
  parameter [8:0] RXLPM_GC_CFG = 9'b111100010;
  parameter [2:0] RXLPM_GC_CFG2 = 3'b001;
  parameter [13:0] RXLPM_HF_CFG = 14'b00001111110000;
  parameter [4:0] RXLPM_HF_CFG2 = 5'b01010;
  parameter [3:0] RXLPM_HF_CFG3 = 4'b0000;
  parameter [0:0] RXLPM_HOLD_DURING_EIDLE = 1'b0;
  parameter [0:0] RXLPM_INCM_CFG = 1'b0;
  parameter [0:0] RXLPM_IPCM_CFG = 1'b0;
  parameter [17:0] RXLPM_LF_CFG = 18'b000000001111110000;
  parameter [4:0] RXLPM_LF_CFG2 = 5'b01010;
  parameter [2:0] RXLPM_OSINT_CFG = 3'b100;
  parameter [6:0] RXOOB_CFG = 7'b0000110;
  parameter RXOOB_CLK_CFG_FABRIC = 1'b0;
  parameter [4:0] RXOSCALRESET_TIME = 5'b00011;
  parameter [4:0] RXOSCALRESET_TIMEOUT = 5'b00000;
  parameter [1:0] RXOUT_DIV = 2'b01;
  parameter [4:0] RXPCSRESET_TIME = 5'b00001;
  parameter [23:0] RXPHDLY_CFG = 24'h084000;
  parameter [23:0] RXPH_CFG = 24'hC00002;
  parameter [4:0] RXPH_MONITOR_SEL = 5'b00000;
  parameter [2:0] RXPI_CFG0 = 3'b000;
  parameter [0:0] RXPI_CFG1 = 1'b0;
  parameter [0:0] RXPI_CFG2 = 1'b0;
  parameter [4:0] RXPMARESET_TIME = 5'b00011;
  parameter [0:0] RXPRBS_ERR_LOOPBACK = 1'b0;
  parameter [3:0] RXSLIDE_AUTO_WAIT = 7;
  parameter RXSLIDE_MODE_AUTO = 1'b0;
  parameter RXSLIDE_MODE_PCS = 1'b0;
  parameter RXSLIDE_MODE_PMA = 1'b0;
  parameter [0:0] RXSYNC_MULTILANE = 1'b0;
  parameter [0:0] RXSYNC_OVRD = 1'b0;
  parameter [0:0] RXSYNC_SKIP_DA = 1'b0;
  parameter [15:0] RX_BIAS_CFG = 16'b0000111100110011;
  parameter [5:0] RX_BUFFER_CFG = 6'b000000;
  parameter [4:0] RX_CLK25_DIV = 5'b00110;
  parameter [0:0] RX_CLKMUX_EN = 1'b1;
  parameter [1:0] RX_CM_SEL = 2'b11;
  parameter [3:0] RX_CM_TRIM = 4'b0100;
  parameter [2:0] RX_DATA_WIDTH = 3'b011;
  parameter [5:0] RX_DDI_SEL = 6'b000000;
  parameter [13:0] RX_DEBUG_CFG = 14'b00000000000000;
  parameter RX_DEFER_RESET_BUF_EN = 1'b1;
  parameter RX_DISPERR_SEQ_MATCH = 1'b1;
  parameter [12:0] RX_OS_CFG = 13'b0001111110000;
  parameter [4:0] RX_SIG_VALID_DLY = 5'b01001;
  parameter RX_XCLK_SEL_RXUSR = 1'b0;
  parameter [6:0] SAS_MAX_COM = 64;
  parameter [5:0] SAS_MIN_COM = 36;
  parameter [3:0] SATA_BURST_SEQ_LEN = 4'b1111;
  parameter [2:0] SATA_BURST_VAL = 3'b100;
  parameter [2:0] SATA_EIDLE_VAL = 3'b100;
  parameter [5:0] SATA_MAX_BURST = 8;
  parameter [5:0] SATA_MAX_INIT = 21;
  parameter [5:0] SATA_MAX_WAKE = 7;
  parameter [5:0] SATA_MIN_BURST = 4;
  parameter [5:0] SATA_MIN_INIT = 12;
  parameter [5:0] SATA_MIN_WAKE = 4;
  parameter SATA_PLL_CFG_VCO_1500MHZ = 1'b0;
  parameter SATA_PLL_CFG_VCO_750MHZ = 1'b0;
  parameter SHOW_REALIGN_COMMA = 1'b1;
  parameter SIM_RECEIVER_DETECT_PASS = 1'b1;
  parameter SIM_RESET_SPEEDUP = 1'b1;
  parameter SIM_TX_EIDLE_DRIVE_LEVEL = "X";
  parameter SIM_VERSION = "1.0";
  parameter [14:0] TERM_RCAL_CFG = 15'b100001000010000;
  parameter [2:0] TERM_RCAL_OVRD = 3'b000;
  parameter [7:0] TRANS_TIME_RATE = 8'h0E;
  parameter [31:0] TST_RSV = 32'h00000000;
  parameter TXBUF_EN = 1'b1;
  parameter TXBUF_RESET_ON_RATE_CHANGE = 1'b0;
  parameter [15:0] TXDLY_CFG = 16'h0010;
  parameter [8:0] TXDLY_LCFG = 9'h020;
  parameter [15:0] TXDLY_TAP_CFG = 16'h0000;
  parameter TXGEARBOX_EN = 1'b0;
  parameter [0:0] TXOOB_CFG = 1'b0;
  parameter [1:0] TXOUT_DIV = 2'b01;
  parameter [4:0] TXPCSRESET_TIME = 5'b00001;
  parameter [23:0] TXPHDLY_CFG = 24'h084000;
  parameter [15:0] TXPH_CFG = 16'h0400;
  parameter [4:0] TXPH_MONITOR_SEL = 5'b00000;
  parameter [1:0] TXPI_CFG0 = 2'b00;
  parameter [1:0] TXPI_CFG1 = 2'b00;
  parameter [1:0] TXPI_CFG2 = 2'b00;
  parameter [0:0] TXPI_CFG3 = 1'b0;
  parameter [0:0] TXPI_CFG4 = 1'b0;
  parameter [2:0] TXPI_CFG5 = 3'b000;
  parameter [0:0] TXPI_GREY_SEL = 1'b0;
  parameter [0:0] TXPI_INVSTROBE_SEL = 1'b0;
  parameter TXPI_PPMCLK_SEL_TXUSRCLK2 = 1'b1;
  parameter [7:0] TXPI_PPM_CFG = 8'b00000000;
  parameter [2:0] TXPI_SYNFREQ_PPM = 3'b000;
  parameter [4:0] TXPMARESET_TIME = 5'b00001;
  parameter [0:0] TXSYNC_MULTILANE = 1'b0;
  parameter [0:0] TXSYNC_OVRD = 1'b0;
  parameter [0:0] TXSYNC_SKIP_DA = 1'b0;
  parameter [4:0] TX_CLK25_DIV = 5'b00110;
  parameter [0:0] TX_CLKMUX_EN = 1'b1;
  parameter [2:0] TX_DATA_WIDTH = 3'b011;
  parameter [5:0] TX_DEEMPH0 = 6'b000000;
  parameter [5:0] TX_DEEMPH1 = 6'b000000;
  parameter TX_DRIVE_MODE_PIPE = 1'b0;
  parameter [2:0] TX_EIDLE_ASSERT_DELAY = 3'b110;
  parameter [2:0] TX_EIDLE_DEASSERT_DELAY = 3'b100;
  parameter TX_LOOPBACK_DRIVE_HIZ = 1'b0;
  parameter [0:0] TX_MAINCURSOR_SEL = 1'b0;
  parameter [6:0] TX_MARGIN_FULL_0 = 7'b1001110;
  parameter [6:0] TX_MARGIN_FULL_1 = 7'b1001001;
  parameter [6:0] TX_MARGIN_FULL_2 = 7'b1000101;
  parameter [6:0] TX_MARGIN_FULL_3 = 7'b1000010;
  parameter [6:0] TX_MARGIN_FULL_4 = 7'b1000000;
  parameter [6:0] TX_MARGIN_LOW_0 = 7'b1000110;
  parameter [6:0] TX_MARGIN_LOW_1 = 7'b1000100;
  parameter [6:0] TX_MARGIN_LOW_2 = 7'b1000010;
  parameter [6:0] TX_MARGIN_LOW_3 = 7'b1000000;
  parameter [6:0] TX_MARGIN_LOW_4 = 7'b1000000;
  parameter [0:0] TX_PREDRIVER_MODE = 1'b0;
  parameter [13:0] TX_RXDETECT_CFG = 14'h1832;
  parameter [2:0] TX_RXDETECT_REF = 3'b100;
  parameter TX_XCLK_SEL_TXUSR = 1'b1;
  parameter [0:0] UCODEER_CLR = 1'b0;
  parameter [0:0] USE_PCS_CLK_PHASE_SEL = 1'b0;

  parameter INV_TXUSRCLK = 1'b1;
  parameter INV_TXUSRCLK2 = 1'b1;
  parameter INV_TXPHDLYTSTCLK = 1'b1;
  parameter INV_SIGVALIDCLK = 1'b1;
  parameter INV_RXUSRCLK = 1'b1;
  parameter INV_RXUSRCLK2 = 1'b1;
  parameter INV_DRPCLK = 1'b1;
  parameter INV_DMONITORCLK = 1'b1;
  parameter INV_CLKRSVD0 = 1'b1;
  parameter INV_CLKRSVD1 = 1'b1;
endmodule

module PCIE_2_1_VPR (
  output CFGAERECRCCHECKEN,
  output CFGAERECRCGENEN,
  input [4:0] CFGAERINTERRUPTMSGNUM,
  output CFGAERROOTERRCORRERRRECEIVED,
  output CFGAERROOTERRCORRERRREPORTINGEN,
  output CFGAERROOTERRFATALERRRECEIVED,
  output CFGAERROOTERRFATALERRREPORTINGEN,
  output CFGAERROOTERRNONFATALERRRECEIVED,
  output CFGAERROOTERRNONFATALERRREPORTINGEN,
  output CFGBRIDGESERREN,
  output CFGCOMMANDBUSMASTERENABLE,
  output CFGCOMMANDINTERRUPTDISABLE,
  output CFGCOMMANDIOENABLE,
  output CFGCOMMANDMEMENABLE,
  output CFGCOMMANDSERREN,
  output CFGDEVCONTROL2ARIFORWARDEN,
  output CFGDEVCONTROL2ATOMICEGRESSBLOCK,
  output CFGDEVCONTROL2ATOMICREQUESTEREN,
  output CFGDEVCONTROL2CPLTIMEOUTDIS,
  output [3:0] CFGDEVCONTROL2CPLTIMEOUTVAL,
  output CFGDEVCONTROL2IDOCPLEN,
  output CFGDEVCONTROL2IDOREQEN,
  output CFGDEVCONTROL2LTREN,
  output CFGDEVCONTROL2TLPPREFIXBLOCK,
  output CFGDEVCONTROLAUXPOWEREN,
  output CFGDEVCONTROLCORRERRREPORTINGEN,
  output CFGDEVCONTROLENABLERO,
  output CFGDEVCONTROLEXTTAGEN,
  output CFGDEVCONTROLFATALERRREPORTINGEN,
  output [2:0] CFGDEVCONTROLMAXPAYLOAD,
  output [2:0] CFGDEVCONTROLMAXREADREQ,
  output CFGDEVCONTROLNONFATALREPORTINGEN,
  output CFGDEVCONTROLNOSNOOPEN,
  output CFGDEVCONTROLPHANTOMEN,
  output CFGDEVCONTROLURERRREPORTINGEN,
  input [15:0] CFGDEVID,
  output CFGDEVSTATUSCORRERRDETECTED,
  output CFGDEVSTATUSFATALERRDETECTED,
  output CFGDEVSTATUSNONFATALERRDETECTED,
  output CFGDEVSTATUSURDETECTED,
  input [7:0] CFGDSBUSNUMBER,
  input [4:0] CFGDSDEVICENUMBER,
  input [2:0] CFGDSFUNCTIONNUMBER,
  input [63:0] CFGDSN,
  input CFGERRACSN,
  input [127:0] CFGERRAERHEADERLOG,
  output CFGERRAERHEADERLOGSETN,
  input CFGERRATOMICEGRESSBLOCKEDN,
  input CFGERRCORN,
  input CFGERRCPLABORTN,
  output CFGERRCPLRDYN,
  input CFGERRCPLTIMEOUTN,
  input CFGERRCPLUNEXPECTN,
  input CFGERRECRCN,
  input CFGERRINTERNALCORN,
  input CFGERRINTERNALUNCORN,
  input CFGERRLOCKEDN,
  input CFGERRMALFORMEDN,
  input CFGERRMCBLOCKEDN,
  input CFGERRNORECOVERYN,
  input CFGERRPOISONEDN,
  input CFGERRPOSTEDN,
  input [47:0] CFGERRTLPCPLHEADER,
  input CFGERRURN,
  input CFGFORCECOMMONCLOCKOFF,
  input CFGFORCEEXTENDEDSYNCON,
  input [2:0] CFGFORCEMPS,
  input CFGINTERRUPTASSERTN,
  input [7:0] CFGINTERRUPTDI,
  output [7:0] CFGINTERRUPTDO,
  output [2:0] CFGINTERRUPTMMENABLE,
  output CFGINTERRUPTMSIENABLE,
  output CFGINTERRUPTMSIXENABLE,
  output CFGINTERRUPTMSIXFM,
  input CFGINTERRUPTN,
  output CFGINTERRUPTRDYN,
  input CFGINTERRUPTSTATN,
  output [1:0] CFGLINKCONTROLASPMCONTROL,
  output CFGLINKCONTROLAUTOBANDWIDTHINTEN,
  output CFGLINKCONTROLBANDWIDTHINTEN,
  output CFGLINKCONTROLCLOCKPMEN,
  output CFGLINKCONTROLCOMMONCLOCK,
  output CFGLINKCONTROLEXTENDEDSYNC,
  output CFGLINKCONTROLHWAUTOWIDTHDIS,
  output CFGLINKCONTROLLINKDISABLE,
  output CFGLINKCONTROLRCB,
  output CFGLINKCONTROLRETRAINLINK,
  output CFGLINKSTATUSAUTOBANDWIDTHSTATUS,
  output CFGLINKSTATUSBANDWIDTHSTATUS,
  output [1:0] CFGLINKSTATUSCURRENTSPEED,
  output CFGLINKSTATUSDLLACTIVE,
  output CFGLINKSTATUSLINKTRAINING,
  output [3:0] CFGLINKSTATUSNEGOTIATEDWIDTH,
  input [3:0] CFGMGMTBYTEENN,
  input [31:0] CFGMGMTDI,
  output [31:0] CFGMGMTDO,
  input [9:0] CFGMGMTDWADDR,
  input CFGMGMTRDENN,
  output CFGMGMTRDWRDONEN,
  input CFGMGMTWRENN,
  input CFGMGMTWRREADONLYN,
  input CFGMGMTWRRW1CASRWN,
  output [15:0] CFGMSGDATA,
  output CFGMSGRECEIVED,
  output CFGMSGRECEIVEDASSERTINTA,
  output CFGMSGRECEIVEDASSERTINTB,
  output CFGMSGRECEIVEDASSERTINTC,
  output CFGMSGRECEIVEDASSERTINTD,
  output CFGMSGRECEIVEDDEASSERTINTA,
  output CFGMSGRECEIVEDDEASSERTINTB,
  output CFGMSGRECEIVEDDEASSERTINTC,
  output CFGMSGRECEIVEDDEASSERTINTD,
  output CFGMSGRECEIVEDERRCOR,
  output CFGMSGRECEIVEDERRFATAL,
  output CFGMSGRECEIVEDERRNONFATAL,
  output CFGMSGRECEIVEDPMASNAK,
  output CFGMSGRECEIVEDPMETO,
  output CFGMSGRECEIVEDPMETOACK,
  output CFGMSGRECEIVEDPMPME,
  output CFGMSGRECEIVEDSETSLOTPOWERLIMIT,
  output CFGMSGRECEIVEDUNLOCK,
  input [4:0] CFGPCIECAPINTERRUPTMSGNUM,
  output [2:0] CFGPCIELINKSTATE,
  output CFGPMCSRPMEEN,
  output CFGPMCSRPMESTATUS,
  output [1:0] CFGPMCSRPOWERSTATE,
  input [1:0] CFGPMFORCESTATE,
  input CFGPMFORCESTATEENN,
  input CFGPMHALTASPML0SN,
  input CFGPMHALTASPML1N,
  output CFGPMRCVASREQL1N,
  output CFGPMRCVENTERL1N,
  output CFGPMRCVENTERL23N,
  output CFGPMRCVREQACKN,
  input CFGPMSENDPMETON,
  input CFGPMTURNOFFOKN,
  input CFGPMWAKEN,
  input [7:0] CFGPORTNUMBER,
  input [7:0] CFGREVID,
  output CFGROOTCONTROLPMEINTEN,
  output CFGROOTCONTROLSYSERRCORRERREN,
  output CFGROOTCONTROLSYSERRFATALERREN,
  output CFGROOTCONTROLSYSERRNONFATALERREN,
  output CFGSLOTCONTROLELECTROMECHILCTLPULSE,
  input [15:0] CFGSUBSYSID,
  input [15:0] CFGSUBSYSVENDID,
  output CFGTRANSACTION,
  output [6:0] CFGTRANSACTIONADDR,
  output CFGTRANSACTIONTYPE,
  input CFGTRNPENDINGN,
  output [6:0] CFGVCTCVCMAP,
  input [15:0] CFGVENDID,
  input CMRSTN,
  input CMSTICKYRSTN,
  input [1:0] DBGMODE,
  output DBGSCLRA,
  output DBGSCLRB,
  output DBGSCLRC,
  output DBGSCLRD,
  output DBGSCLRE,
  output DBGSCLRF,
  output DBGSCLRG,
  output DBGSCLRH,
  output DBGSCLRI,
  output DBGSCLRJ,
  output DBGSCLRK,
  input DBGSUBMODE,
  output [63:0] DBGVECA,
  output [63:0] DBGVECB,
  output [11:0] DBGVECC,
  input DLRSTN,
  input [8:0] DRPADDR,
  input DRPCLK,
  input [15:0] DRPDI,
  output [15:0] DRPDO,
  input DRPEN,
  output DRPRDY,
  input DRPWE,
  input FUNCLVLRSTN,
  output LL2BADDLLPERR,
  output LL2BADTLPERR,
  output [4:0] LL2LINKSTATUS,
  output LL2PROTOCOLERR,
  output LL2RECEIVERERR,
  output LL2REPLAYROERR,
  output LL2REPLAYTOERR,
  input LL2SENDASREQL1,
  input LL2SENDENTERL1,
  input LL2SENDENTERL23,
  input LL2SENDPMACK,
  input LL2SUSPENDNOW,
  output LL2SUSPENDOK,
  output LL2TFCINIT1SEQ,
  output LL2TFCINIT2SEQ,
  input LL2TLPRCV,
  output LL2TXIDLE,
  output LNKCLKEN,
  output [12:0] MIMRXRADDR,
  input [67:0] MIMRXRDATA,
  output MIMRXREN,
  output [12:0] MIMRXWADDR,
  output [67:0] MIMRXWDATA,
  output MIMRXWEN,
  output [12:0] MIMTXRADDR,
  input [68:0] MIMTXRDATA,
  output MIMTXREN,
  output [12:0] MIMTXWADDR,
  output [68:0] MIMTXWDATA,
  output MIMTXWEN,
  input PIPECLK,
  input PIPERX0CHANISALIGNED,
  input [1:0] PIPERX0CHARISK,
  input [15:0] PIPERX0DATA,
  input PIPERX0ELECIDLE,
  input PIPERX0PHYSTATUS,
  output PIPERX0POLARITY,
  input [2:0] PIPERX0STATUS,
  input PIPERX0VALID,
  input PIPERX1CHANISALIGNED,
  input [1:0] PIPERX1CHARISK,
  input [15:0] PIPERX1DATA,
  input PIPERX1ELECIDLE,
  input PIPERX1PHYSTATUS,
  output PIPERX1POLARITY,
  input [2:0] PIPERX1STATUS,
  input PIPERX1VALID,
  input PIPERX2CHANISALIGNED,
  input [1:0] PIPERX2CHARISK,
  input [15:0] PIPERX2DATA,
  input PIPERX2ELECIDLE,
  input PIPERX2PHYSTATUS,
  output PIPERX2POLARITY,
  input [2:0] PIPERX2STATUS,
  input PIPERX2VALID,
  input PIPERX3CHANISALIGNED,
  input [1:0] PIPERX3CHARISK,
  input [15:0] PIPERX3DATA,
  input PIPERX3ELECIDLE,
  input PIPERX3PHYSTATUS,
  output PIPERX3POLARITY,
  input [2:0] PIPERX3STATUS,
  input PIPERX3VALID,
  input PIPERX4CHANISALIGNED,
  input [1:0] PIPERX4CHARISK,
  input [15:0] PIPERX4DATA,
  input PIPERX4ELECIDLE,
  input PIPERX4PHYSTATUS,
  output PIPERX4POLARITY,
  input [2:0] PIPERX4STATUS,
  input PIPERX4VALID,
  input PIPERX5CHANISALIGNED,
  input [1:0] PIPERX5CHARISK,
  input [15:0] PIPERX5DATA,
  input PIPERX5ELECIDLE,
  input PIPERX5PHYSTATUS,
  output PIPERX5POLARITY,
  input [2:0] PIPERX5STATUS,
  input PIPERX5VALID,
  input PIPERX6CHANISALIGNED,
  input [1:0] PIPERX6CHARISK,
  input [15:0] PIPERX6DATA,
  input PIPERX6ELECIDLE,
  input PIPERX6PHYSTATUS,
  output PIPERX6POLARITY,
  input [2:0] PIPERX6STATUS,
  input PIPERX6VALID,
  input PIPERX7CHANISALIGNED,
  input [1:0] PIPERX7CHARISK,
  input [15:0] PIPERX7DATA,
  input PIPERX7ELECIDLE,
  input PIPERX7PHYSTATUS,
  output PIPERX7POLARITY,
  input [2:0] PIPERX7STATUS,
  input PIPERX7VALID,
  output [1:0] PIPETX0CHARISK,
  output PIPETX0COMPLIANCE,
  output [15:0] PIPETX0DATA,
  output PIPETX0ELECIDLE,
  output [1:0] PIPETX0POWERDOWN,
  output [1:0] PIPETX1CHARISK,
  output PIPETX1COMPLIANCE,
  output [15:0] PIPETX1DATA,
  output PIPETX1ELECIDLE,
  output [1:0] PIPETX1POWERDOWN,
  output [1:0] PIPETX2CHARISK,
  output PIPETX2COMPLIANCE,
  output [15:0] PIPETX2DATA,
  output PIPETX2ELECIDLE,
  output [1:0] PIPETX2POWERDOWN,
  output [1:0] PIPETX3CHARISK,
  output PIPETX3COMPLIANCE,
  output [15:0] PIPETX3DATA,
  output PIPETX3ELECIDLE,
  output [1:0] PIPETX3POWERDOWN,
  output [1:0] PIPETX4CHARISK,
  output PIPETX4COMPLIANCE,
  output [15:0] PIPETX4DATA,
  output PIPETX4ELECIDLE,
  output [1:0] PIPETX4POWERDOWN,
  output [1:0] PIPETX5CHARISK,
  output PIPETX5COMPLIANCE,
  output [15:0] PIPETX5DATA,
  output PIPETX5ELECIDLE,
  output [1:0] PIPETX5POWERDOWN,
  output [1:0] PIPETX6CHARISK,
  output PIPETX6COMPLIANCE,
  output [15:0] PIPETX6DATA,
  output PIPETX6ELECIDLE,
  output [1:0] PIPETX6POWERDOWN,
  output [1:0] PIPETX7CHARISK,
  output PIPETX7COMPLIANCE,
  output [15:0] PIPETX7DATA,
  output PIPETX7ELECIDLE,
  output [1:0] PIPETX7POWERDOWN,
  output PIPETXDEEMPH,
  output [2:0] PIPETXMARGIN,
  output PIPETXRATE,
  output PIPETXRCVRDET,
  output PIPETXRESET,
  input [4:0] PL2DIRECTEDLSTATE,
  output PL2L0REQ,
  output PL2LINKUP,
  output PL2RECEIVERERR,
  output PL2RECOVERY,
  output PL2RXELECIDLE,
  output [1:0] PL2RXPMSTATE,
  output PL2SUSPENDOK,
  input [2:0] PLDBGMODE,
  output [11:0] PLDBGVEC,
  output PLDIRECTEDCHANGEDONE,
  input PLDIRECTEDLINKAUTON,
  input [1:0] PLDIRECTEDLINKCHANGE,
  input PLDIRECTEDLINKSPEED,
  input [1:0] PLDIRECTEDLINKWIDTH,
  input [5:0] PLDIRECTEDLTSSMNEW,
  input PLDIRECTEDLTSSMNEWVLD,
  input PLDIRECTEDLTSSMSTALL,
  input PLDOWNSTREAMDEEMPHSOURCE,
  output [2:0] PLINITIALLINKWIDTH,
  output [1:0] PLLANEREVERSALMODE,
  output PLLINKGEN2CAP,
  output PLLINKPARTNERGEN2SUPPORTED,
  output PLLINKUPCFGCAP,
  output [5:0] PLLTSSMSTATE,
  output PLPHYLNKUPN,
  output PLRECEIVEDHOTRST,
  input PLRSTN,
  output [1:0] PLRXPMSTATE,
  output PLSELLNKRATE,
  output [1:0] PLSELLNKWIDTH,
  input PLTRANSMITHOTRST,
  output [2:0] PLTXPMSTATE,
  input PLUPSTREAMPREFERDEEMPH,
  output RECEIVEDFUNCLVLRSTN,
  input SYSRSTN,
  input TL2ASPMSUSPENDCREDITCHECK,
  output TL2ASPMSUSPENDCREDITCHECKOK,
  output TL2ASPMSUSPENDREQ,
  output TL2ERRFCPE,
  output [63:0] TL2ERRHDR,
  output TL2ERRMALFORMED,
  output TL2ERRRXOVERFLOW,
  output TL2PPMSUSPENDOK,
  input TL2PPMSUSPENDREQ,
  input TLRSTN,
  output [11:0] TRNFCCPLD,
  output [7:0] TRNFCCPLH,
  output [11:0] TRNFCNPD,
  output [7:0] TRNFCNPH,
  output [11:0] TRNFCPD,
  output [7:0] TRNFCPH,
  input [2:0] TRNFCSEL,
  output TRNLNKUP,
  output [7:0] TRNRBARHIT,
  output [127:0] TRNRD,
  output [63:0] TRNRDLLPDATA,
  output [1:0] TRNRDLLPSRCRDY,
  input TRNRDSTRDY,
  output TRNRECRCERR,
  output TRNREOF,
  output TRNRERRFWD,
  input TRNRFCPRET,
  input TRNRNPOK,
  input TRNRNPREQ,
  output [1:0] TRNRREM,
  output TRNRSOF,
  output TRNRSRCDSC,
  output TRNRSRCRDY,
  output [5:0] TRNTBUFAV,
  input TRNTCFGGNT,
  output TRNTCFGREQ,
  input [127:0] TRNTD,
  input [31:0] TRNTDLLPDATA,
  output TRNTDLLPDSTRDY,
  input TRNTDLLPSRCRDY,
  output [3:0] TRNTDSTRDY,
  input TRNTECRCGEN,
  input TRNTEOF,
  output TRNTERRDROP,
  input TRNTERRFWD,
  input [1:0] TRNTREM,
  input TRNTSOF,
  input TRNTSRCDSC,
  input TRNTSRCRDY,
  input TRNTSTR,
  input USERCLK,
  input USERCLK2,
  output USERRSTN
);
  parameter [11:0] AER_BASE_PTR = 12'd0;
  parameter AER_CAP_ECRC_CHECK_CAPABLE = "FALSE";
  parameter AER_CAP_ECRC_GEN_CAPABLE = "FALSE";
  parameter [15:0] AER_CAP_ID = 16'd0;
  parameter AER_CAP_MULTIHEADER = "FALSE";
  parameter [11:0] AER_CAP_NEXTPTR = 12'd0;
  parameter AER_CAP_ON = "FALSE";
  parameter [23:0] AER_CAP_OPTIONAL_ERR_SUPPORT = 24'd0;
  parameter AER_CAP_PERMIT_ROOTERR_UPDATE = "FALSE";
  parameter [3:0] AER_CAP_VERSION = 4'd0;
  parameter ALLOW_X8_GEN2 = "FALSE";
  parameter [31:0] BAR0 = 32'd0;
  parameter [31:0] BAR1 = 32'd0;
  parameter [31:0] BAR2 = 32'd0;
  parameter [31:0] BAR3 = 32'd0;
  parameter [31:0] BAR4 = 32'd0;
  parameter [31:0] BAR5 = 32'd0;
  parameter [7:0] CAPABILITIES_PTR = 8'd0;
  parameter [31:0] CARDBUS_CIS_POINTER = 32'd0;
  parameter [23:0] CLASS_CODE = 24'd0;
  parameter CMD_INTX_IMPLEMENTED = "FALSE";
  parameter CPL_TIMEOUT_DISABLE_SUPPORTED = "FALSE";
  parameter [3:0] CPL_TIMEOUT_RANGES_SUPPORTED = 4'd0;
  parameter [6:0] CRM_MODULE_RSTS = 7'd0;
  parameter DEV_CAP2_ARI_FORWARDING_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ATOMICOP32_COMPLETER_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ATOMICOP64_COMPLETER_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ATOMICOP_ROUTING_SUPPORTED = "FALSE";
  parameter DEV_CAP2_CAS128_COMPLETER_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ENDEND_TLP_PREFIX_SUPPORTED = "FALSE";
  parameter DEV_CAP2_EXTENDED_FMT_FIELD_SUPPORTED = "FALSE";
  parameter DEV_CAP2_LTR_MECHANISM_SUPPORTED = "FALSE";
  parameter [1:0] DEV_CAP2_MAX_ENDEND_TLP_PREFIXES = 2'd0;
  parameter DEV_CAP2_NO_RO_ENABLED_PRPR_PASSING = "FALSE";
  parameter [1:0] DEV_CAP2_TPH_COMPLETER_SUPPORTED = 2'd0;
  parameter DEV_CAP_ENABLE_SLOT_PWR_LIMIT_SCALE = "FALSE";
  parameter DEV_CAP_ENABLE_SLOT_PWR_LIMIT_VALUE = "FALSE";
  parameter DEV_CAP_EXT_TAG_SUPPORTED = "FALSE";
  parameter DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE = "FALSE";
  parameter [2:0] DEV_CAP_MAX_PAYLOAD_SUPPORTED = 3'd0;
  parameter DEV_CAP_ROLE_BASED_ERROR = "FALSE";
  parameter [2:0] DEV_CAP_RSVD_14_12 = 3'd0;
  parameter [1:0] DEV_CAP_RSVD_17_16 = 2'd0;
  parameter [2:0] DEV_CAP_RSVD_31_29 = 3'd0;
  parameter DEV_CONTROL_AUX_POWER_SUPPORTED = "FALSE";
  parameter DEV_CONTROL_EXT_TAG_DEFAULT = "FALSE";
  parameter DISABLE_ASPM_L1_TIMER = "FALSE";
  parameter DISABLE_BAR_FILTERING = "FALSE";
  parameter DISABLE_ERR_MSG = "FALSE";
  parameter DISABLE_ID_CHECK = "FALSE";
  parameter DISABLE_LANE_REVERSAL = "FALSE";
  parameter DISABLE_LOCKED_FILTER = "FALSE";
  parameter DISABLE_PPM_FILTER = "FALSE";
  parameter DISABLE_RX_POISONED_RESP = "FALSE";
  parameter DISABLE_RX_TC_FILTER = "FALSE";
  parameter DISABLE_SCRAMBLING = "FALSE";
  parameter [7:0] DNSTREAM_LINK_NUM = 8'd0;
  parameter [11:0] DSN_BASE_PTR = 12'd0;
  parameter [15:0] DSN_CAP_ID = 16'd0;
  parameter [11:0] DSN_CAP_NEXTPTR = 12'd0;
  parameter DSN_CAP_ON = "FALSE";
  parameter [3:0] DSN_CAP_VERSION = 4'd0;
  parameter [10:0] ENABLE_MSG_ROUTE = 11'd0;
  parameter ENABLE_RX_TD_ECRC_TRIM = "FALSE";
  parameter ENDEND_TLP_PREFIX_FORWARDING_SUPPORTED = "FALSE";
  parameter ENTER_RVRY_EI_L0 = "FALSE";
  parameter EXIT_LOOPBACK_ON_EI = "FALSE";
  parameter [31:0] EXPANSION_ROM = 32'd0;
  parameter [5:0] EXT_CFG_CAP_PTR = 6'd0;
  parameter [9:0] EXT_CFG_XP_CAP_PTR = 10'd0;
  parameter [7:0] HEADER_TYPE = 8'd0;
  parameter [4:0] INFER_EI = 5'd0;
  parameter [7:0] INTERRUPT_PIN = 8'd0;
  parameter INTERRUPT_STAT_AUTO = "FALSE";
  parameter IS_SWITCH = "FALSE";
  parameter [9:0] LAST_CONFIG_DWORD = 10'd0;
  parameter LINK_CAP_ASPM_OPTIONALITY = "FALSE";
  parameter [1:0] LINK_CAP_ASPM_SUPPORT = 2'd0;
  parameter LINK_CAP_CLOCK_POWER_MANAGEMENT = "FALSE";
  parameter LINK_CAP_DLL_LINK_ACTIVE_REPORTING_CAP = "FALSE";
  parameter LINK_CAP_LINK_BANDWIDTH_NOTIFICATION_CAP = "FALSE";
  parameter [3:0] LINK_CAP_MAX_LINK_SPEED = 4'd0;
  parameter [5:0] LINK_CAP_MAX_LINK_WIDTH = 6'd0;
  parameter [0:0] LINK_CAP_RSVD_23 = 1'd0;
  parameter LINK_CAP_SURPRISE_DOWN_ERROR_CAPABLE = "FALSE";
  parameter LINK_CTRL2_DEEMPHASIS = "FALSE";
  parameter LINK_CTRL2_HW_AUTONOMOUS_SPEED_DISABLE = "FALSE";
  parameter [3:0] LINK_CTRL2_TARGET_LINK_SPEED = 4'd0;
  parameter LINK_STATUS_SLOT_CLOCK_CONFIG = "FALSE";
  parameter [14:0] LL_ACK_TIMEOUT = 15'd0;
  parameter LL_ACK_TIMEOUT_EN = "FALSE";
  parameter [1:0] LL_ACK_TIMEOUT_FUNC = 2'd0;
  parameter [14:0] LL_REPLAY_TIMEOUT = 15'd0;
  parameter LL_REPLAY_TIMEOUT_EN = "FALSE";
  parameter [1:0] LL_REPLAY_TIMEOUT_FUNC = 2'd0;
  parameter [5:0] LTSSM_MAX_LINK_WIDTH = 6'd0;
  parameter MPS_FORCE = "FALSE";
  parameter [7:0] MSIX_BASE_PTR = 8'd0;
  parameter [7:0] MSIX_CAP_ID = 8'd0;
  parameter [7:0] MSIX_CAP_NEXTPTR = 8'd0;
  parameter MSIX_CAP_ON = "FALSE";
  parameter [2:0] MSIX_CAP_PBA_BIR = 3'd0;
  parameter [28:0] MSIX_CAP_PBA_OFFSET = 29'd0;
  parameter [2:0] MSIX_CAP_TABLE_BIR = 3'd0;
  parameter [28:0] MSIX_CAP_TABLE_OFFSET = 29'd0;
  parameter [10:0] MSIX_CAP_TABLE_SIZE = 11'd0;
  parameter [7:0] MSI_BASE_PTR = 8'd0;
  parameter MSI_CAP_64_BIT_ADDR_CAPABLE = "FALSE";
  parameter [7:0] MSI_CAP_ID = 8'd0;
  parameter [2:0] MSI_CAP_MULTIMSGCAP = 3'd0;
  parameter [7:0] MSI_CAP_NEXTPTR = 8'd0;
  parameter MSI_CAP_ON = "FALSE";
  parameter MSI_CAP_PER_VECTOR_MASKING_CAPABLE = "FALSE";
  parameter [7:0] N_FTS_COMCLK_GEN1 = 8'd255;
  parameter [7:0] N_FTS_COMCLK_GEN2 = 8'd255;
  parameter [7:0] N_FTS_GEN1 = 8'd255;
  parameter [7:0] N_FTS_GEN2 = 8'd255;
  parameter [7:0] PCIE_BASE_PTR = 8'd0;
  parameter [7:0] PCIE_CAP_CAPABILITY_ID = 8'd0;
  parameter [3:0] PCIE_CAP_CAPABILITY_VERSION = 4'd0;
  parameter [3:0] PCIE_CAP_DEVICE_PORT_TYPE = 4'd0;
  parameter [7:0] PCIE_CAP_NEXTPTR = 8'd0;
  parameter PCIE_CAP_ON = "FALSE";
  parameter [1:0] PCIE_CAP_RSVD_15_14 = 2'd0;
  parameter PCIE_CAP_SLOT_IMPLEMENTED = "FALSE";
  parameter [3:0] PCIE_REVISION = 4'd2;
  parameter PL_FAST_TRAIN = "FALSE";
  parameter [14:0] PM_ASPML0S_TIMEOUT = 15'd0;
  parameter PM_ASPML0S_TIMEOUT_EN = "FALSE";
  parameter [1:0] PM_ASPML0S_TIMEOUT_FUNC = 2'd0;
  parameter PM_ASPM_FASTEXIT = "FALSE";
  parameter [7:0] PM_BASE_PTR = 8'd0;
  parameter PM_CAP_D1SUPPORT = "FALSE";
  parameter PM_CAP_D2SUPPORT = "FALSE";
  parameter PM_CAP_DSI = "FALSE";
  parameter [7:0] PM_CAP_ID = 8'd0;
  parameter [7:0] PM_CAP_NEXTPTR = 8'd0;
  parameter PM_CAP_ON = "FALSE";
  parameter [4:0] PM_CAP_PMESUPPORT = 5'd0;
  parameter PM_CAP_PME_CLOCK = "FALSE";
  parameter [0:0] PM_CAP_RSVD_04 = 1'd0;
  parameter [2:0] PM_CAP_VERSION = 3'd3;
  parameter PM_CSR_B2B3 = "FALSE";
  parameter PM_CSR_BPCCEN = "FALSE";
  parameter PM_CSR_NOSOFTRST = "FALSE";
  parameter [7:0] PM_DATA0 = 8'd0;
  parameter [7:0] PM_DATA1 = 8'd0;
  parameter [7:0] PM_DATA2 = 8'd0;
  parameter [7:0] PM_DATA3 = 8'd0;
  parameter [7:0] PM_DATA4 = 8'd0;
  parameter [7:0] PM_DATA5 = 8'd0;
  parameter [7:0] PM_DATA6 = 8'd0;
  parameter [7:0] PM_DATA7 = 8'd0;
  parameter [1:0] PM_DATA_SCALE0 = 2'd0;
  parameter [1:0] PM_DATA_SCALE1 = 2'd0;
  parameter [1:0] PM_DATA_SCALE2 = 2'd0;
  parameter [1:0] PM_DATA_SCALE3 = 2'd0;
  parameter [1:0] PM_DATA_SCALE4 = 2'd0;
  parameter [1:0] PM_DATA_SCALE5 = 2'd0;
  parameter [1:0] PM_DATA_SCALE6 = 2'd0;
  parameter [1:0] PM_DATA_SCALE7 = 2'd0;
  parameter PM_MF = "FALSE";
  parameter [11:0] RBAR_BASE_PTR = 12'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR0 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR1 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR2 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR3 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR4 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR5 = 5'd0;
  parameter [15:0] RBAR_CAP_ID = 16'd0;
  parameter [2:0] RBAR_CAP_INDEX0 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX1 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX2 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX3 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX4 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX5 = 3'd0;
  parameter [11:0] RBAR_CAP_NEXTPTR = 12'd0;
  parameter RBAR_CAP_ON = "FALSE";
  parameter [31:0] RBAR_CAP_SUP0 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP1 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP2 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP3 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP4 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP5 = 32'd0;
  parameter [3:0] RBAR_CAP_VERSION = 4'd0;
  parameter [2:0] RBAR_NUM = 3'd0;
  parameter [1:0] RECRC_CHK = 2'd0;
  parameter RECRC_CHK_TRIM = "FALSE";
  parameter ROOT_CAP_CRS_SW_VISIBILITY = "FALSE";
  parameter [1:0] RP_AUTO_SPD = 2'd0;
  parameter [4:0] RP_AUTO_SPD_LOOPCNT = 5'd0;
  parameter SELECT_DLL_IF = "FALSE";
  parameter SLOT_CAP_ATT_BUTTON_PRESENT = "FALSE";
  parameter SLOT_CAP_ATT_INDICATOR_PRESENT = "FALSE";
  parameter SLOT_CAP_ELEC_INTERLOCK_PRESENT = "FALSE";
  parameter SLOT_CAP_HOTPLUG_CAPABLE = "FALSE";
  parameter SLOT_CAP_HOTPLUG_SURPRISE = "FALSE";
  parameter SLOT_CAP_MRL_SENSOR_PRESENT = "FALSE";
  parameter SLOT_CAP_NO_CMD_COMPLETED_SUPPORT = "FALSE";
  parameter [12:0] SLOT_CAP_PHYSICAL_SLOT_NUM = 13'd0;
  parameter SLOT_CAP_POWER_CONTROLLER_PRESENT = "FALSE";
  parameter SLOT_CAP_POWER_INDICATOR_PRESENT = "FALSE";
  parameter [7:0] SLOT_CAP_SLOT_POWER_LIMIT_VALUE = 8'd0;
  parameter [0:0] SPARE_BIT0 = 1'd0;
  parameter [0:0] SPARE_BIT1 = 1'd0;
  parameter [0:0] SPARE_BIT2 = 1'd0;
  parameter [0:0] SPARE_BIT3 = 1'd0;
  parameter [0:0] SPARE_BIT4 = 1'd0;
  parameter [0:0] SPARE_BIT5 = 1'd0;
  parameter [0:0] SPARE_BIT6 = 1'd0;
  parameter [0:0] SPARE_BIT7 = 1'd0;
  parameter [0:0] SPARE_BIT8 = 1'd0;
  parameter [7:0] SPARE_BYTE0 = 8'd0;
  parameter [7:0] SPARE_BYTE1 = 8'd0;
  parameter [7:0] SPARE_BYTE2 = 8'd0;
  parameter [7:0] SPARE_BYTE3 = 8'd0;
  parameter [31:0] SPARE_WORD0 = 32'd0;
  parameter [31:0] SPARE_WORD1 = 32'd0;
  parameter [31:0] SPARE_WORD2 = 32'd0;
  parameter [31:0] SPARE_WORD3 = 32'd0;
  parameter SSL_MESSAGE_AUTO = "FALSE";
  parameter TECRC_EP_INV = "FALSE";
  parameter TL_RBYPASS = "FALSE";
  parameter [1:0] TL_RX_RAM_RDATA_LATENCY = 2'd1;
  parameter TL_TFC_DISABLE = "FALSE";
  parameter TL_TX_CHECKS_DISABLE = "FALSE";
  parameter [1:0] TL_TX_RAM_RDATA_LATENCY = 2'd1;
  parameter TRN_DW = "FALSE";
  parameter TRN_NP_FC = "FALSE";
  parameter UPCONFIG_CAPABLE = "FALSE";
  parameter UPSTREAM_FACING = "FALSE";
  parameter UR_ATOMIC = "FALSE";
  parameter UR_CFG1 = "FALSE";
  parameter UR_INV_REQ = "FALSE";
  parameter UR_PRS_RESPONSE = "FALSE";
  parameter USER_CLK2_DIV2 = "FALSE";
  parameter USE_RID_PINS = "FALSE";
  parameter VC0_CPL_INFINITE = "FALSE";
  parameter [12:0] VC0_RX_RAM_LIMIT = 13'd0;
  parameter [6:0] VC0_TOTAL_CREDITS_CH = 7'd36;
  parameter [6:0] VC0_TOTAL_CREDITS_NPH = 7'd12;
  parameter [6:0] VC0_TOTAL_CREDITS_PH = 7'd32;
  parameter [11:0] VC_BASE_PTR = 12'd0;
  parameter [15:0] VC_CAP_ID = 16'd0;
  parameter [11:0] VC_CAP_NEXTPTR = 12'd0;
  parameter VC_CAP_ON = "FALSE";
  parameter VC_CAP_REJECT_SNOOP_TRANSACTIONS = "FALSE";
  parameter [3:0] VC_CAP_VERSION = 4'd0;
  parameter [11:0] VSEC_BASE_PTR = 12'd0;
  parameter [15:0] VSEC_CAP_HDR_ID = 16'd0;
  parameter [11:0] VSEC_CAP_HDR_LENGTH = 12'd0;
  parameter [3:0] VSEC_CAP_HDR_REVISION = 4'd0;
  parameter [15:0] VSEC_CAP_ID = 16'd0;
  parameter VSEC_CAP_IS_LINK_VISIBLE = "FALSE";
  parameter [11:0] VSEC_CAP_NEXTPTR = 12'd0;
  parameter VSEC_CAP_ON = "FALSE";
  parameter [3:0] VSEC_CAP_VERSION = 4'd0;
  parameter [2:0] DEV_CAP_ENDPOINT_L0S_LATENCY = 3'd0;
  parameter [2:0] DEV_CAP_ENDPOINT_L1_LATENCY = 3'd0;
  parameter [1:0] DEV_CAP_PHANTOM_FUNCTIONS_SUPPORT = 2'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2 = 3'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_GEN2 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_GEN2 = 3'd0;
  parameter [0:0] LINK_CONTROL_RCB = 1'd0;
  parameter [0:0] MSI_CAP_MULTIMSG_EXTENSION = 1'd0;
  parameter [2:0] PM_CAP_AUXCURRENT = 3'd0;
  parameter [1:0] SLOT_CAP_SLOT_POWER_LIMIT_SCALE = 2'd0;
  parameter [2:0] USER_CLK_FREQ = 3'd0;
  parameter [2:0] PL_AUTO_CONFIG = 3'd0;
  parameter [0:0] TL_RX_RAM_RADDR_LATENCY = 1'd0;
  parameter [0:0] TL_RX_RAM_WRITE_LATENCY = 1'd0;
  parameter [0:0] TL_TX_RAM_RADDR_LATENCY = 1'd0;
  parameter [0:0] TL_TX_RAM_WRITE_LATENCY = 1'd0;
  parameter [10:0] VC0_TOTAL_CREDITS_CD = 11'd0;
  parameter [10:0] VC0_TOTAL_CREDITS_NPD = 11'd0;
  parameter [10:0] VC0_TOTAL_CREDITS_PD = 11'd0;
  parameter [4:0] VC0_TX_LASTPACKET = 5'd0;
  parameter [1:0] CFG_ECRC_ERR_CPLSTAT = 2'd0;
endmodule
