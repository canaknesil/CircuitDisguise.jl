// MIT License

// Copyright (c) 2024 Can Aknesil

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


// This cell library file is used for replacement of some netlist
// cells before disguise.
//
// Example usage: techmap -map <this-file>

// For a LUT6_2 cell in a netlist file, SDF file contains one LUT6 and
// one LUT5. The following mapping makes the netlist to have the same
// structure as the SDF file.

module LUT6_2(output O6, output O5, input I0, I1, I2, I3, I4, I5);
   parameter [63:0] INIT = 0;
   LUT6 #(.INIT(INIT)) LUT6 (
     .O(O6),
     .I0(I0),
     .I1(I1),
     .I2(I2),
     .I3(I3),
     .I4(I4),
     .I5(I5));
   LUT5 #(.INIT(INIT[31:0])) LUT5 (
     .O(O5),
     .I0(I0),
     .I1(I1),
     .I2(I2),
     .I3(I3),
     .I4(I4));
endmodule

module IBUF(output O, input I);
   parameter CCIO_EN = "TRUE";
   wire A;
   INBUF INBUF_INST (.PAD(I),
		     .O(A));
   IBUFCTRL IBUFCTRL_INST (.I(A),
			   .O(O));
endmodule

module RAM32M16
  #(parameter INIT_A = 64'h0000000000000000,
    parameter INIT_B = 64'h0000000000000000,
    parameter INIT_C = 64'h0000000000000000,
    parameter INIT_D = 64'h0000000000000000,
    parameter INIT_E = 64'h0000000000000000,
    parameter INIT_F = 64'h0000000000000000,
    parameter INIT_G = 64'h0000000000000000,
    parameter INIT_H = 64'h0000000000000000,
    parameter IS_WCLK_INVERTED = 1'b0)
    
  // (.DOA({DOA1,DOA0}), // This syntax isn't support by Yosys yet.
  //   .DOB({DOB1,DOB0}),
  //   .DOC({DOC1,DOC0}),
  //   .DOD({DOD1,DOD0}),
  //   .DOE({DOE1,DOE0}),
  //   .DOF({DOF1,DOF0}),
  //   .DOG({DOG1,DOG0}),
  //   .DOH({DOH1,DOH0}),
  //   .ADDRA({ADDRA4,ADDRA3,ADDRA2,ADDRA1,ADDRA0}),
  //   .ADDRB({ADDRB4,ADDRB3,ADDRB2,ADDRB1,ADDRB0}),
  //   .ADDRC({ADDRC4,ADDRC3,ADDRC2,ADDRC1,ADDRC0}),
  //   .ADDRD({ADDRD4,ADDRD3,ADDRD2,ADDRD1,ADDRD0}),
  //   .ADDRE({ADDRE4,ADDRE3,ADDRE2,ADDRE1,ADDRE0}),
  //   .ADDRF({ADDRF4,ADDRF3,ADDRF2,ADDRF1,ADDRF0}),
  //   .ADDRG({ADDRG4,ADDRG3,ADDRG2,ADDRG1,ADDRG0}),
  //   .ADDRH({ADDRH4,ADDRH3,ADDRH2,ADDRH1,ADDRH0}),
  //   .DIA({DIA1,DIA0}),
  //   .DIB({DIB1,DIB0}),
  //   .DIC({DIC1,DIC0}),
  //   .DID({DID1,DID0}),
  //   .DIE({DIE1,DIE0}),
  //   .DIF({DIF1,DIF0}),
  //   .DIG({DIG1,DIG0}),
  //   .DIH({DIH1,DIH0}),
  //   WCLK,
  //   WE);
  // input WCLK;
  // input WE;
  // output DOA0;
  // output DOA1;
  // output DOB0;
  // output DOB1;
  // output DOC0;
  // output DOC1;
  // output DOD0;
  // output DOD1;
  // output DOE0;
  // output DOE1;
  // output DOF0;
  // output DOF1;
  // output DOG0;
  // output DOG1;
  // output DOH0;
  // output DOH1;
  // input ADDRA0;
  // input ADDRA1;
  // input ADDRA2;
  // input ADDRA3;
  // input ADDRA4;
  // input ADDRB0;
  // input ADDRB1;
  // input ADDRB2;
  // input ADDRB3;
  // input ADDRB4;
  // input ADDRC0;
  // input ADDRC1;
  // input ADDRC2;
  // input ADDRC3;
  // input ADDRC4;
  // input ADDRD0;
  // input ADDRD1;
  // input ADDRD2;
  // input ADDRD3;
  // input ADDRD4;
  // input ADDRE0;
  // input ADDRE1;
  // input ADDRE2;
  // input ADDRE3;
  // input ADDRE4;
  // input ADDRF0;
  // input ADDRF1;
  // input ADDRF2;
  // input ADDRF3;
  // input ADDRF4;
  // input ADDRG0;
  // input ADDRG1;
  // input ADDRG2;
  // input ADDRG3;
  // input ADDRG4;
  // input ADDRH0;
  // input ADDRH1;
  // input ADDRH2;
  // input ADDRH3;
  // input ADDRH4;
  // input DIA0;
  // input DIA1;
  // input DIB0;
  // input DIB1;
  // input DIC0;
  // input DIC1;
  // input DID0;
  // input DID1;
  // input DIE0;
  // input DIE1;
  // input DIF0;
  // input DIF1;
  // input DIG0;
  // input DIG1;
  // input DIH0;
  // input DIH1;

  (DOA,
   DOB,
   DOC,
   DOD,
   DOE,
   DOF,
   DOG,
   DOH,
   ADDRA,
   ADDRB,
   ADDRC,
   ADDRD,
   ADDRE,
   ADDRF,
   ADDRG,
   ADDRH,
   DIA,
   DIB,
   DIC,
   DID,
   DIE,
   DIF,
   DIG,
   DIH,
   WCLK,
   WE);
   input WCLK;
   input WE;
   
   input [4:0] ADDRA;
   input [4:0] ADDRB;
   input [4:0] ADDRC;
   input [4:0] ADDRD;
   input [4:0] ADDRE;
   input [4:0] ADDRF;
   input [4:0] ADDRG;
   input [4:0] ADDRH;
   wire	 ADDRA0;
   wire	 ADDRA1;
   wire	 ADDRA2;
   wire	 ADDRA3;
   wire	 ADDRA4;
   wire	 ADDRB0;
   wire	 ADDRB1;
   wire	 ADDRB2;
   wire	 ADDRB3;
   wire	 ADDRB4;
   wire	 ADDRC0;
   wire	 ADDRC1;
   wire	 ADDRC2;
   wire	 ADDRC3;
   wire	 ADDRC4;
   wire	 ADDRD0;
   wire	 ADDRD1;
   wire	 ADDRD2;
   wire	 ADDRD3;
   wire	 ADDRD4;
   wire	 ADDRE0;
   wire	 ADDRE1;
   wire	 ADDRE2;
   wire	 ADDRE3;
   wire	 ADDRE4;
   wire	 ADDRF0;
   wire	 ADDRF1;
   wire	 ADDRF2;
   wire	 ADDRF3;
   wire	 ADDRF4;
   wire	 ADDRG0;
   wire	 ADDRG1;
   wire	 ADDRG2;
   wire	 ADDRG3;
   wire	 ADDRG4;
   wire	 ADDRH0;
   wire	 ADDRH1;
   wire	 ADDRH2;
   wire	 ADDRH3;
   wire	 ADDRH4;
   assign ADDRA0 = ADDRA[0];
   assign ADDRA1 = ADDRA[1];
   assign ADDRA2 = ADDRA[2];
   assign ADDRA3 = ADDRA[3];
   assign ADDRA4 = ADDRA[4];
   assign ADDRB0 = ADDRB[0];
   assign ADDRB1 = ADDRB[1];
   assign ADDRB2 = ADDRB[2];
   assign ADDRB3 = ADDRB[3];
   assign ADDRB4 = ADDRB[4];
   assign ADDRC0 = ADDRC[0];
   assign ADDRC1 = ADDRC[1];
   assign ADDRC2 = ADDRC[2];
   assign ADDRC3 = ADDRC[3];
   assign ADDRC4 = ADDRC[4];
   assign ADDRD0 = ADDRD[0];
   assign ADDRD1 = ADDRD[1];
   assign ADDRD2 = ADDRD[2];
   assign ADDRD3 = ADDRD[3];
   assign ADDRD4 = ADDRD[4];
   assign ADDRE0 = ADDRE[0];
   assign ADDRE1 = ADDRE[1];
   assign ADDRE2 = ADDRE[2];
   assign ADDRE3 = ADDRE[3];
   assign ADDRE4 = ADDRE[4];
   assign ADDRF0 = ADDRF[0];
   assign ADDRF1 = ADDRF[1];
   assign ADDRF2 = ADDRF[2];
   assign ADDRF3 = ADDRF[3];
   assign ADDRF4 = ADDRF[4];
   assign ADDRG0 = ADDRG[0];
   assign ADDRG1 = ADDRG[1];
   assign ADDRG2 = ADDRG[2];
   assign ADDRG3 = ADDRG[3];
   assign ADDRG4 = ADDRG[4];
   assign ADDRH0 = ADDRH[0];
   assign ADDRH1 = ADDRH[1];
   assign ADDRH2 = ADDRH[2];
   assign ADDRH3 = ADDRH[3];
   assign ADDRH4 = ADDRH[4];

   input [1:0] DIA;
   input [1:0] DIB;
   input [1:0] DIC;
   input [1:0] DID;
   input [1:0] DIE;
   input [1:0] DIF;
   input [1:0] DIG;
   input [1:0] DIH;
   wire	  DIA0;
   wire	  DIA1;
   wire	  DIB0;
   wire	  DIB1;
   wire	  DIC0;
   wire	  DIC1;
   wire	  DID0;
   wire	  DID1;
   wire	  DIE0;
   wire	  DIE1;
   wire	  DIF0;
   wire	  DIF1;
   wire	  DIG0;
   wire	  DIG1;
   wire	  DIH0;
   wire	  DIH1;
   assign DIA0 = DIA[0];
   assign DIA1 = DIA[1];
   assign DIB0 = DIB[0];
   assign DIB1 = DIB[1];
   assign DIC0 = DIC[0];
   assign DIC1 = DIC[1];
   assign DID0 = DID[0];
   assign DID1 = DID[1];
   assign DIE0 = DIE[0];
   assign DIE1 = DIE[1];
   assign DIF0 = DIF[0];
   assign DIF1 = DIF[1];
   assign DIG0 = DIG[0];
   assign DIG1 = DIG[1];
   assign DIH0 = DIH[0];
   assign DIH1 = DIH[1];
   
   output [1:0] DOA;
   output [1:0] DOB;
   output [1:0] DOC;
   output [1:0] DOD;
   output [1:0] DOE;
   output [1:0] DOF;
   output [1:0] DOG;
   output [1:0] DOH;
   wire	  DOA0;
   wire	  DOA1;
   wire	  DOB0;
   wire	  DOB1;
   wire	  DOC0;
   wire	  DOC1;
   wire	  DOD0;
   wire	  DOD1;
   wire	  DOE0;
   wire	  DOE1;
   wire	  DOF0;
   wire	  DOF1;
   wire	  DOG0;
   wire	  DOG1;
   wire	  DOH0;
   wire	  DOH1;
   assign DOA[0] = DOA0;
   assign DOA[1] = DOA1;
   assign DOB[0] = DOB0;
   assign DOB[1] = DOB1;
   assign DOC[0] = DOC0;
   assign DOC[1] = DOC1;
   assign DOD[0] = DOD0;
   assign DOD[1] = DOD1;
   assign DOE[0] = DOE0;
   assign DOE[1] = DOE1;
   assign DOF[0] = DOF0;
   assign DOF[1] = DOF1;
   assign DOG[0] = DOG0;
   assign DOG[1] = DOG1;
   assign DOH[0] = DOH0;
   assign DOH[1] = DOH1;

   
  wire WCLK;
  wire WE;

  RAMD32 RAMA
       (.CLK(WCLK),
        .I(DIA0),
        .O(DOA0),
        .RADR0(ADDRA0),
        .RADR1(ADDRA1),
        .RADR2(ADDRA2),
        .RADR3(ADDRA3),
        .RADR4(ADDRA4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMA_D1
       (.CLK(WCLK),
        .I(DIA1),
        .O(DOA1),
        .RADR0(ADDRA0),
        .RADR1(ADDRA1),
        .RADR2(ADDRA2),
        .RADR3(ADDRA3),
        .RADR4(ADDRA4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMB
       (.CLK(WCLK),
        .I(DIB0),
        .O(DOB0),
        .RADR0(ADDRB0),
        .RADR1(ADDRB1),
        .RADR2(ADDRB2),
        .RADR3(ADDRB3),
        .RADR4(ADDRB4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMB_D1
       (.CLK(WCLK),
        .I(DIB1),
        .O(DOB1),
        .RADR0(ADDRB0),
        .RADR1(ADDRB1),
        .RADR2(ADDRB2),
        .RADR3(ADDRB3),
        .RADR4(ADDRB4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMC
       (.CLK(WCLK),
        .I(DIC0),
        .O(DOC0),
        .RADR0(ADDRC0),
        .RADR1(ADDRC1),
        .RADR2(ADDRC2),
        .RADR3(ADDRC3),
        .RADR4(ADDRC4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMC_D1
       (.CLK(WCLK),
        .I(DIC1),
        .O(DOC1),
        .RADR0(ADDRC0),
        .RADR1(ADDRC1),
        .RADR2(ADDRC2),
        .RADR3(ADDRC3),
        .RADR4(ADDRC4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMD
       (.CLK(WCLK),
        .I(DID0),
        .O(DOD0),
        .RADR0(ADDRD0),
        .RADR1(ADDRD1),
        .RADR2(ADDRD2),
        .RADR3(ADDRD3),
        .RADR4(ADDRD4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMD_D1
       (.CLK(WCLK),
        .I(DID1),
        .O(DOD1),
        .RADR0(ADDRD0),
        .RADR1(ADDRD1),
        .RADR2(ADDRD2),
        .RADR3(ADDRD3),
        .RADR4(ADDRD4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAME
       (.CLK(WCLK),
        .I(DIE0),
        .O(DOE0),
        .RADR0(ADDRE0),
        .RADR1(ADDRE1),
        .RADR2(ADDRE2),
        .RADR3(ADDRE3),
        .RADR4(ADDRE4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAME_D1
       (.CLK(WCLK),
        .I(DIE1),
        .O(DOE1),
        .RADR0(ADDRE0),
        .RADR1(ADDRE1),
        .RADR2(ADDRE2),
        .RADR3(ADDRE3),
        .RADR4(ADDRE4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMF
       (.CLK(WCLK),
        .I(DIF0),
        .O(DOF0),
        .RADR0(ADDRF0),
        .RADR1(ADDRF1),
        .RADR2(ADDRF2),
        .RADR3(ADDRF3),
        .RADR4(ADDRF4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMF_D1
       (.CLK(WCLK),
        .I(DIF1),
        .O(DOF1),
        .RADR0(ADDRF0),
        .RADR1(ADDRF1),
        .RADR2(ADDRF2),
        .RADR3(ADDRF3),
        .RADR4(ADDRF4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMG
       (.CLK(WCLK),
        .I(DIG0),
        .O(DOG0),
        .RADR0(ADDRG0),
        .RADR1(ADDRG1),
        .RADR2(ADDRG2),
        .RADR3(ADDRG3),
        .RADR4(ADDRG4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMD32 RAMG_D1
       (.CLK(WCLK),
        .I(DIG1),
        .O(DOG1),
        .RADR0(ADDRG0),
        .RADR1(ADDRG1),
        .RADR2(ADDRG2),
        .RADR3(ADDRG3),
        .RADR4(ADDRG4),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WE(WE));
  RAMS32 RAMH
       (.ADR0(ADDRH0),
        .ADR1(ADDRH1),
        .ADR2(ADDRH2),
        .ADR3(ADDRH3),
        .ADR4(ADDRH4),
        .CLK(WCLK),
        .I(DIH0),
        .O(DOH0),
        .WE(WE));
  RAMS32 RAMH_D1
       (.ADR0(ADDRH0),
        .ADR1(ADDRH1),
        .ADR2(ADDRH2),
        .ADR3(ADDRH3),
        .ADR4(ADDRH4),
        .CLK(WCLK),
        .I(DIH1),
        .O(DOH1),
        .WE(WE));
endmodule // RAM32M16

module RAM64M8
  #(parameter INIT_A = 128'h0000000000000000,
    parameter INIT_B = 128'h0000000000000000,
    parameter INIT_C = 128'h0000000000000000,
    parameter INIT_D = 128'h0000000000000000,
    parameter INIT_E = 128'h0000000000000000,
    parameter INIT_F = 128'h0000000000000000,
    parameter INIT_G = 128'h0000000000000000,
    parameter INIT_H = 128'h0000000000000000,
    parameter IS_WCLK_INVERTED = 1'b0)
  (DOA,
   DOB,
   DOC,
   DOD,
   DOE,
   DOF,
   DOG,
   DOH,
   ADDRA,
   ADDRB,
   ADDRC,
   ADDRD,
   ADDRE,
   ADDRF,
   ADDRG,
   ADDRH,
   DIA,
   DIB,
   DIC,
   DID,
   DIE,
   DIF,
   DIG,
   DIH,
   WCLK,
   WE);
   input WCLK;
   input WE;
   
   input [5:0] ADDRA;
   input [5:0] ADDRB;
   input [5:0] ADDRC;
   input [5:0] ADDRD;
   input [5:0] ADDRE;
   input [5:0] ADDRF;
   input [5:0] ADDRG;
   input [5:0] ADDRH;
   wire	 ADDRA0;
   wire	 ADDRA1;
   wire	 ADDRA2;
   wire	 ADDRA3;
   wire	 ADDRA4;
   wire	 ADDRA5;
   wire	 ADDRB0;
   wire	 ADDRB1;
   wire	 ADDRB2;
   wire	 ADDRB3;
   wire	 ADDRB4;
   wire	 ADDRB5;
   wire	 ADDRC0;
   wire	 ADDRC1;
   wire	 ADDRC2;
   wire	 ADDRC3;
   wire	 ADDRC4;
   wire	 ADDRC5;
   wire	 ADDRD0;
   wire	 ADDRD1;
   wire	 ADDRD2;
   wire	 ADDRD3;
   wire	 ADDRD4;
   wire	 ADDRD5;
   wire	 ADDRE0;
   wire	 ADDRE1;
   wire	 ADDRE2;
   wire	 ADDRE3;
   wire	 ADDRE4;
   wire	 ADDRE5;
   wire	 ADDRF0;
   wire	 ADDRF1;
   wire	 ADDRF2;
   wire	 ADDRF3;
   wire	 ADDRF4;
   wire	 ADDRF5;
   wire	 ADDRG0;
   wire	 ADDRG1;
   wire	 ADDRG2;
   wire	 ADDRG3;
   wire	 ADDRG4;
   wire	 ADDRG5;
   wire	 ADDRH0;
   wire	 ADDRH1;
   wire	 ADDRH2;
   wire	 ADDRH3;
   wire	 ADDRH4;
   wire	 ADDRH5;
   assign ADDRA0 = ADDRA[0];
   assign ADDRA1 = ADDRA[1];
   assign ADDRA2 = ADDRA[2];
   assign ADDRA3 = ADDRA[3];
   assign ADDRA4 = ADDRA[4];
   assign ADDRA5 = ADDRA[5];
   assign ADDRB0 = ADDRB[0];
   assign ADDRB1 = ADDRB[1];
   assign ADDRB2 = ADDRB[2];
   assign ADDRB3 = ADDRB[3];
   assign ADDRB4 = ADDRB[4];
   assign ADDRB5 = ADDRB[5];
   assign ADDRC0 = ADDRC[0];
   assign ADDRC1 = ADDRC[1];
   assign ADDRC2 = ADDRC[2];
   assign ADDRC3 = ADDRC[3];
   assign ADDRC4 = ADDRC[4];
   assign ADDRC5 = ADDRC[5];
   assign ADDRD0 = ADDRD[0];
   assign ADDRD1 = ADDRD[1];
   assign ADDRD2 = ADDRD[2];
   assign ADDRD3 = ADDRD[3];
   assign ADDRD4 = ADDRD[4];
   assign ADDRD5 = ADDRD[5];
   assign ADDRE0 = ADDRE[0];
   assign ADDRE1 = ADDRE[1];
   assign ADDRE2 = ADDRE[2];
   assign ADDRE3 = ADDRE[3];
   assign ADDRE4 = ADDRE[4];
   assign ADDRE5 = ADDRE[5];
   assign ADDRF0 = ADDRF[0];
   assign ADDRF1 = ADDRF[1];
   assign ADDRF2 = ADDRF[2];
   assign ADDRF3 = ADDRF[3];
   assign ADDRF4 = ADDRF[4];
   assign ADDRF5 = ADDRF[5];
   assign ADDRG0 = ADDRG[0];
   assign ADDRG1 = ADDRG[1];
   assign ADDRG2 = ADDRG[2];
   assign ADDRG3 = ADDRG[3];
   assign ADDRG4 = ADDRG[4];
   assign ADDRG5 = ADDRG[5];
   assign ADDRH0 = ADDRH[0];
   assign ADDRH1 = ADDRH[1];
   assign ADDRH2 = ADDRH[2];
   assign ADDRH3 = ADDRH[3];
   assign ADDRH4 = ADDRH[4];
   assign ADDRH5 = ADDRH[5];

   input  DIA;
   input  DIB;
   input  DIC;
   input  DID;
   input  DIE;
   input  DIF;
   input  DIG;
   input  DIH;
   
   output  DOA;
   output  DOB;
   output  DOC;
   output  DOD;
   output  DOE;
   output  DOF;
   output  DOG;
   output  DOH;

   wire DIA;
  wire DIB;
  wire DIC;
  wire DID;
  wire DIE;
  wire DIF;
  wire DIG;
  wire DIH;
  wire DOA;
  wire DOB;
  wire DOC;
  wire DOD;
  wire DOE;
  wire DOF;
  wire DOG;
  wire DOH;
   
  wire WCLK;
  wire WE;

   RAMD64E RAMA
       (.CLK(WCLK),
        .I(DIA),
        .O(DOA),
        .RADR0(ADDRA0),
        .RADR1(ADDRA1),
        .RADR2(ADDRA2),
        .RADR3(ADDRA3),
        .RADR4(ADDRA4),
        .RADR5(ADDRA5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAMA_WADR6_UNCONNECTED),
        .WADR7(NLW_RAMA_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E RAMB
       (.CLK(WCLK),
        .I(DIB),
        .O(DOB),
        .RADR0(ADDRB0),
        .RADR1(ADDRB1),
        .RADR2(ADDRB2),
        .RADR3(ADDRB3),
        .RADR4(ADDRB4),
        .RADR5(ADDRB5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAMB_WADR6_UNCONNECTED),
        .WADR7(NLW_RAMB_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E RAMC
       (.CLK(WCLK),
        .I(DIC),
        .O(DOC),
        .RADR0(ADDRC0),
        .RADR1(ADDRC1),
        .RADR2(ADDRC2),
        .RADR3(ADDRC3),
        .RADR4(ADDRC4),
        .RADR5(ADDRC5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAMC_WADR6_UNCONNECTED),
        .WADR7(NLW_RAMC_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E RAMD
       (.CLK(WCLK),
        .I(DID),
        .O(DOD),
        .RADR0(ADDRD0),
        .RADR1(ADDRD1),
        .RADR2(ADDRD2),
        .RADR3(ADDRD3),
        .RADR4(ADDRD4),
        .RADR5(ADDRD5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAMD_WADR6_UNCONNECTED),
        .WADR7(NLW_RAMD_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E RAME
       (.CLK(WCLK),
        .I(DIE),
        .O(DOE),
        .RADR0(ADDRE0),
        .RADR1(ADDRE1),
        .RADR2(ADDRE2),
        .RADR3(ADDRE3),
        .RADR4(ADDRE4),
        .RADR5(ADDRE5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAME_WADR6_UNCONNECTED),
        .WADR7(NLW_RAME_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E RAMF
       (.CLK(WCLK),
        .I(DIF),
        .O(DOF),
        .RADR0(ADDRF0),
        .RADR1(ADDRF1),
        .RADR2(ADDRF2),
        .RADR3(ADDRF3),
        .RADR4(ADDRF4),
        .RADR5(ADDRF5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAMF_WADR6_UNCONNECTED),
        .WADR7(NLW_RAMF_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E RAMG
       (.CLK(WCLK),
        .I(DIG),
        .O(DOG),
        .RADR0(ADDRG0),
        .RADR1(ADDRG1),
        .RADR2(ADDRG2),
        .RADR3(ADDRG3),
        .RADR4(ADDRG4),
        .RADR5(ADDRG5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAMG_WADR6_UNCONNECTED),
        .WADR7(NLW_RAMG_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E RAMH
       (.CLK(WCLK),
        .I(DIH),
        .O(DOH),
        .RADR0(ADDRH0),
        .RADR1(ADDRH1),
        .RADR2(ADDRH2),
        .RADR3(ADDRH3),
        .RADR4(ADDRH4),
        .RADR5(ADDRH5),
        .WADR0(ADDRH0),
        .WADR1(ADDRH1),
        .WADR2(ADDRH2),
        .WADR3(ADDRH3),
        .WADR4(ADDRH4),
        .WADR5(ADDRH5),
        .WADR6(NLW_RAMH_WADR6_UNCONNECTED),
        .WADR7(NLW_RAMH_WADR7_UNCONNECTED),
        .WE(WE));
endmodule // RAM64M8

module RAM32X1D
  #(parameter INIT = 32'h00000000,
    parameter IS_WCLK_INVERTED = 1'b0)
   (DPO,
    SPO,
    A0,
    A1,
    A2,
    A3,
    A4,
    D,
    DPRA0,
    DPRA1,
    DPRA2,
    DPRA3,
    DPRA4,
    WCLK,
    WE);
  output DPO;
  output SPO;
  input A0;
  input A1;
  input A2;
  input A3;
  input A4;
  input D;
  input DPRA0;
  input DPRA1;
  input DPRA2;
  input DPRA3;
  input DPRA4;
  input WCLK;
  input WE;

  wire A0;
  wire A1;
  wire A2;
  wire A3;
  wire A4;
  wire D;
  wire DPO;
  wire DPRA0;
  wire DPRA1;
  wire DPRA2;
  wire DPRA3;
  wire DPRA4;
  wire SPO;
  wire WCLK;
  wire WE;

  RAMD32 DP
       (.CLK(WCLK),
        .I(D),
        .O(DPO),
        .RADR0(DPRA0),
        .RADR1(DPRA1),
        .RADR2(DPRA2),
        .RADR3(DPRA3),
        .RADR4(DPRA4),
        .WADR0(A0),
        .WADR1(A1),
        .WADR2(A2),
        .WADR3(A3),
        .WADR4(A4),
        .WE(WE));
  RAMD32 SP
       (.CLK(WCLK),
        .I(D),
        .O(SPO),
        .RADR0(A0),
        .RADR1(A1),
        .RADR2(A2),
        .RADR3(A3),
        .RADR4(A4),
        .WADR0(A0),
        .WADR1(A1),
        .WADR2(A2),
        .WADR3(A3),
        .WADR4(A4),
        .WE(WE));
endmodule // RAM32X1D

module RAM64X1D
  #(parameter INIT = 64'h00000000,
    parameter IS_WCLK_INVERTED = 1'b0)
   (DPO,
    SPO,
    A0,
    A1,
    A2,
    A3,
    A4,
    A5,
    D,
    DPRA0,
    DPRA1,
    DPRA2,
    DPRA3,
    DPRA4,
    DPRA5,
    WCLK,
    WE);
  output DPO;
  output SPO;
  input A0;
  input A1;
  input A2;
  input A3;
  input A4;
  input A5;
  input D;
  input DPRA0;
  input DPRA1;
  input DPRA2;
  input DPRA3;
  input DPRA4;
  input DPRA5;
  input WCLK;
  input WE;

  wire A0;
  wire A1;
  wire A2;
  wire A3;
  wire A4;
  wire A5;
  wire D;
  wire DPO;
  wire DPRA0;
  wire DPRA1;
  wire DPRA2;
  wire DPRA3;
  wire DPRA4;
  wire DPRA5;
  wire SPO;
  wire WCLK;
  wire WE;

   RAMD64E DP
       (.CLK(WCLK),
        .I(D),
        .O(DPO),
        .RADR0(DPRA0),
        .RADR1(DPRA1),
        .RADR2(DPRA2),
        .RADR3(DPRA3),
        .RADR4(DPRA4),
        .RADR5(DPRA5),
        .WADR0(A0),
        .WADR1(A1),
        .WADR2(A2),
        .WADR3(A3),
        .WADR4(A4),
        .WADR5(A5),
        .WADR6(NLW_DP_WADR6_UNCONNECTED),
        .WADR7(NLW_DP_WADR7_UNCONNECTED),
        .WE(WE));
  RAMD64E SP
       (.CLK(WCLK),
        .I(D),
        .O(SPO),
        .RADR0(A0),
        .RADR1(A1),
        .RADR2(A2),
        .RADR3(A3),
        .RADR4(A4),
        .RADR5(A5),
        .WADR0(A0),
        .WADR1(A1),
        .WADR2(A2),
        .WADR3(A3),
        .WADR4(A4),
        .WADR5(A5),
        .WADR6(NLW_SP_WADR6_UNCONNECTED),
        .WADR7(NLW_SP_WADR7_UNCONNECTED),
        .WE(WE));
endmodule

module DSP48E2
  #(parameter AMULTSEL = "A",                    // Selects A input to multiplier (A, AD)
    parameter A_INPUT = "DIRECT",                // Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
    parameter BMULTSEL = "B",                    // Selects B input to multiplier (AD, B)
    parameter B_INPUT = "DIRECT",                // Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
    parameter PREADDINSEL = "A",                 // Selects input to pre-adder (A, B)
    parameter RND = 48'h000000000000,            // Rounding Constant
    parameter USE_MULT = "MULTIPLY",             // Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
    parameter USE_SIMD = "ONE48",                // SIMD selection (FOUR12, ONE48, TWO24)
    parameter USE_WIDEXOR = "FALSE",             // Use the Wide XOR function (FALSE, TRUE)
    parameter XORSIMD = "XOR24_48_96",           // Mode of operation for the Wide XOR (XOR12, XOR24_48_96)
    parameter AUTORESET_PATDET = "NO_RESET",     // NO_RESET, RESET_MATCH, RESET_NOT_MATCH
    parameter AUTORESET_PRIORITY = "RESET",      // Priority of AUTORESET vs. CEP (CEP, RESET).
    parameter MASK = 48'h3fffffffffff,           // 48-bit mask value for pattern detect (1=ignore)
    parameter PATTERN = 48'h000000000000,        // 48-bit pattern match for pattern detect
    parameter SEL_MASK = "MASK",                 // C, MASK, ROUNDING_MODE1, ROUNDING_MODE2
    parameter SEL_PATTERN = "PATTERN",           // Select pattern value (C, PATTERN)
    parameter USE_PATTERN_DETECT = "NO_PATDET",  // Enable pattern detect (NO_PATDET, PATDET)
    parameter IS_ALUMODE_INVERTED = 4'b0000,     // Optional inversion for ALUMODE
    parameter IS_CARRYIN_INVERTED = 1'b0,        // Optional inversion for CARRYIN
    parameter IS_CLK_INVERTED = 1'b0,            // Optional inversion for CLK
    parameter IS_INMODE_INVERTED = 5'b00000,     // Optional inversion for INMODE
    parameter IS_OPMODE_INVERTED = 9'b000000000, // Optional inversion for OPMODE
    parameter IS_RSTALLCARRYIN_INVERTED = 1'b0,  // Optional inversion for RSTALLCARRYIN
    parameter IS_RSTALUMODE_INVERTED = 1'b0,     // Optional inversion for RSTALUMODE
    parameter IS_RSTA_INVERTED = 1'b0,           // Optional inversion for RSTA
    parameter IS_RSTB_INVERTED = 1'b0,           // Optional inversion for RSTB
    parameter IS_RSTCTRL_INVERTED = 1'b0,        // Optional inversion for RSTCTRL
    parameter IS_RSTC_INVERTED = 1'b0,           // Optional inversion for RSTC
    parameter IS_RSTD_INVERTED = 1'b0,           // Optional inversion for RSTD
    parameter IS_RSTINMODE_INVERTED = 1'b0,      // Optional inversion for RSTINMODE
    parameter IS_RSTM_INVERTED = 1'b0,           // Optional inversion for RSTM
    parameter IS_RSTP_INVERTED = 1'b0,           // Optional inversion for RSTP
    parameter ACASCREG = 1,                      // Number of pipeline stages between A/ACIN and ACOUT (0-2)
    parameter ADREG = 1,                         // Pipeline stages for pre-adder (0-1)
    parameter ALUMODEREG = 1,                    // Pipeline stages for ALUMODE (0-1)
    parameter AREG = 1,                          // Pipeline stages for A (0-2)
    parameter BCASCREG = 1,                      // Number of pipeline stages between B/BCIN and BCOUT (0-2)
    parameter BREG = 1,                          // Pipeline stages for B (0-2)
    parameter CARRYINREG = 1,                    // Pipeline stages for CARRYIN (0-1)
    parameter CARRYINSELREG = 1,                 // Pipeline stages for CARRYINSEL (0-1)
    parameter CREG = 1,                          // Pipeline stages for C (0-1)
    parameter DREG = 1,                          // Pipeline stages for D (0-1)
    parameter INMODEREG = 1,                     // Pipeline stages for INMODE (0-1)
    parameter MREG = 1,                          // Multiplier pipeline stages (0-1)
    parameter OPMODEREG = 1,                     // Pipeline stages for OPMODE (0-1)
    parameter PREG = 1                           // Number of pipeline stages for P (0-1)
    )
   (ACOUT,
    BCOUT,
    CARRYCASCOUT,
    CARRYOUT,
    MULTSIGNOUT,
    OVERFLOW,
    PATTERNBDETECT,
    PATTERNDETECT,
    PCOUT,
    P,
    UNDERFLOW,
    XOROUT,
    ACIN,
    ALUMODE,
    A,
    BCIN,
    B,
    CARRYCASCIN,
    CARRYIN,
    CARRYINSEL,
    CEA1,
    CEA2,
    CEAD,
    CEALUMODE,
    CEB1,
    CEB2,
    CEC,
    CECARRYIN,
    CECTRL,
    CED,
    CEINMODE,
    CEM,
    CEP,
    CLK,
    C,
    D,
    INMODE,
    MULTSIGNIN,
    OPMODE,
    PCIN,
    RSTA,
    RSTALLCARRYIN,
    RSTALUMODE,
    RSTB,
    RSTC,
    RSTCTRL,
    RSTD,
    RSTINMODE,
    RSTM,
    RSTP);
  output CARRYCASCOUT;
  output MULTSIGNOUT;
  output OVERFLOW;
  output PATTERNBDETECT;
  output PATTERNDETECT;
  output UNDERFLOW;
  input CARRYCASCIN;
  input CARRYIN;
  input CEA1;
  input CEA2;
  input CEAD;
  input CEALUMODE;
  input CEB1;
  input CEB2;
  input CEC;
  input CECARRYIN;
  input CECTRL;
  input CED;
  input CEINMODE;
  input CEM;
  input CEP;
  input CLK;
  input MULTSIGNIN;
  input RSTA;
  input RSTALLCARRYIN;
  input RSTALUMODE;
  input RSTB;
  input RSTC;
  input RSTCTRL;
  input RSTD;
  input RSTINMODE;
  input RSTM;
  input RSTP;

   output [29:0] ACOUT;
   wire [29:0] INNER_ACOUT;
   assign ACOUT[29:0] = INNER_ACOUT[29:0];

   output [17:0] BCOUT;
   wire [17:0]	 INNER_BCOUT;
   assign BCOUT = INNER_BCOUT[17:0];

   output [3:0]	 CARRYOUT;
   wire [3:0] INNER_CARRYOUT;
   assign CARRYOUT = INNER_CARRYOUT[3:0];

   output [47:0] PCOUT;
   wire [47:0] INNER_PCOUT;
   assign PCOUT = INNER_PCOUT[47:0];

   output [47:0] P;
   wire [47:0] INNER_P;
   assign P = INNER_P[47:0];

   output [7:0] XOROUT;
   wire [7:0] INNER_XOROUT;
   assign XOROUT = INNER_XOROUT[7:0];

   input [29:0] ACIN;
   wire [29:0] INNER_ACIN;
   assign INNER_ACIN = ACIN[29:0];

   input [3:0] ALUMODE;
   wire [3:0] INNER_ALUMODE;
   assign INNER_ALUMODE = ALUMODE[3:0];

   input [29:0] A;
   wire [29:0] INNER_A;
   assign INNER_A = A[29:0];

   input [17:0] BCIN;
   wire [17:0] INNER_BCIN;
   assign INNER_BCIN = BCIN[17:0];
  
   input [17:0]	B;
   wire [17:0] INNER_B;
   assign INNER_B = B[17:0];

   input [2:0]	CARRYINSEL;
   wire [2:0] INNER_CARRYINSEL;
   assign INNER_CARRYINSEL = CARRYINSEL[2:0];

   input [47:0]	C;
   wire [47:0] INNER_C;
   assign INNER_C = C[47:0];

   input [26:0]	D;
   wire [26:0] INNER_D;
   assign INNER_D = D[26:0];

   input [4:0] INMODE;
   wire [4:0] INNER_INMODE;
   assign INNER_INMODE = INMODE[4:0];

   input [8:0] OPMODE;
   wire [8:0] INNER_OPMODE;
   assign INNER_OPMODE = OPMODE[8:0];

   input [47:0] PCIN;
   wire [47:0] INNER_PCIN;
   assign INNER_PCIN = PCIN[47:0];
  
  

  // wire INNER_ACIN[0] ;
  // wire INNER_ACIN[10] ;
  // wire INNER_ACIN[11] ;
  // wire INNER_ACIN[12] ;
  // wire INNER_ACIN[13] ;
  // wire INNER_ACIN[14] ;
  // wire INNER_ACIN[15] ;
  // wire INNER_ACIN[16] ;
  // wire INNER_ACIN[17] ;
  // wire INNER_ACIN[18] ;
  // wire INNER_ACIN[19] ;
  // wire INNER_ACIN[1] ;
  // wire INNER_ACIN[20] ;
  // wire INNER_ACIN[21] ;
  // wire INNER_ACIN[22] ;
  // wire INNER_ACIN[23] ;
  // wire INNER_ACIN[24] ;
  // wire INNER_ACIN[25] ;
  // wire INNER_ACIN[26] ;
  // wire INNER_ACIN[27] ;
  // wire INNER_ACIN[28] ;
  // wire INNER_ACIN[29] ;
  // wire INNER_ACIN[2] ;
  // wire INNER_ACIN[3] ;
  // wire INNER_ACIN[4] ;
  // wire INNER_ACIN[5] ;
  // wire INNER_ACIN[6] ;
  // wire INNER_ACIN[7] ;
  // wire INNER_ACIN[8] ;
  // wire INNER_ACIN[9] ;
  // wire INNER_ACOUT[0] ;
  // wire INNER_ACOUT[10] ;
  // wire INNER_ACOUT[11] ;
  // wire INNER_ACOUT[12] ;
  // wire INNER_ACOUT[13] ;
  // wire INNER_ACOUT[14] ;
  // wire INNER_ACOUT[15] ;
  // wire INNER_ACOUT[16] ;
  // wire INNER_ACOUT[17] ;
  // wire INNER_ACOUT[18] ;
  // wire INNER_ACOUT[19] ;
  // wire INNER_ACOUT[1] ;
  // wire INNER_ACOUT[20] ;
  // wire INNER_ACOUT[21] ;
  // wire INNER_ACOUT[22] ;
  // wire INNER_ACOUT[23] ;
  // wire INNER_ACOUT[24] ;
  // wire INNER_ACOUT[25] ;
  // wire INNER_ACOUT[26] ;
  // wire INNER_ACOUT[27] ;
  // wire INNER_ACOUT[28] ;
  // wire INNER_ACOUT[29] ;
  // wire INNER_ACOUT[2] ;
  // wire INNER_ACOUT[3] ;
  // wire INNER_ACOUT[4] ;
  // wire INNER_ACOUT[5] ;
  // wire INNER_ACOUT[6] ;
  // wire INNER_ACOUT[7] ;
  // wire INNER_ACOUT[8] ;
  // wire INNER_ACOUT[9] ;
  // wire INNER_ALUMODE[0] ;
  // wire INNER_ALUMODE[1] ;
  // wire INNER_ALUMODE[2] ;
  // wire INNER_ALUMODE[3] ;
  // wire INNER_A[0] ;
  // wire INNER_A[10] ;
  // wire INNER_A[11] ;
  // wire INNER_A[12] ;
  // wire INNER_A[13] ;
  // wire INNER_A[14] ;
  // wire INNER_A[15] ;
  // wire INNER_A[16] ;
  // wire INNER_A[17] ;
  // wire INNER_A[18] ;
  // wire INNER_A[19] ;
  // wire INNER_A[1] ;
  // wire INNER_A[20] ;
  // wire INNER_A[21] ;
  // wire INNER_A[22] ;
  // wire INNER_A[23] ;
  // wire INNER_A[24] ;
  // wire INNER_A[25] ;
  // wire INNER_A[26] ;
  // wire INNER_A[27] ;
  // wire INNER_A[28] ;
  // wire INNER_A[29] ;
  // wire INNER_A[2] ;
  // wire INNER_A[3] ;
  // wire INNER_A[4] ;
  // wire INNER_A[5] ;
  // wire INNER_A[6] ;
  // wire INNER_A[7] ;
  // wire INNER_A[8] ;
  // wire INNER_A[9] ;
  // wire INNER_BCIN[0] ;
  // wire INNER_BCIN[10] ;
  // wire INNER_BCIN[11] ;
  // wire INNER_BCIN[12] ;
  // wire INNER_BCIN[13] ;
  // wire INNER_BCIN[14] ;
  // wire INNER_BCIN[15] ;
  // wire INNER_BCIN[16] ;
  // wire INNER_BCIN[17] ;
  // wire INNER_BCIN[1] ;
  // wire INNER_BCIN[2] ;
  // wire INNER_BCIN[3] ;
  // wire INNER_BCIN[4] ;
  // wire INNER_BCIN[5] ;
  // wire INNER_BCIN[6] ;
  // wire INNER_BCIN[7] ;
  // wire INNER_BCIN[8] ;
  // wire INNER_BCIN[9] ;
  // wire INNER_BCOUT[0] ;
  // wire INNER_BCOUT[10] ;
  // wire INNER_BCOUT[11] ;
  // wire INNER_BCOUT[12] ;
  // wire INNER_BCOUT[13] ;
  // wire INNER_BCOUT[14] ;
  // wire INNER_BCOUT[15] ;
  // wire INNER_BCOUT[16] ;
  // wire INNER_BCOUT[17] ;
  // wire INNER_BCOUT[1] ;
  // wire INNER_BCOUT[2] ;
  // wire INNER_BCOUT[3] ;
  // wire INNER_BCOUT[4] ;
  // wire INNER_BCOUT[5] ;
  // wire INNER_BCOUT[6] ;
  // wire INNER_BCOUT[7] ;
  // wire INNER_BCOUT[8] ;
  // wire INNER_BCOUT[9] ;
  // wire INNER_B[0] ;
  // wire INNER_B[10] ;
  // wire INNER_B[11] ;
  // wire INNER_B[12] ;
  // wire INNER_B[13] ;
  // wire INNER_B[14] ;
  // wire INNER_B[15] ;
  // wire INNER_B[16] ;
  // wire INNER_B[17] ;
  // wire INNER_B[1] ;
  // wire INNER_B[2] ;
  // wire INNER_B[3] ;
  // wire INNER_B[4] ;
  // wire INNER_B[5] ;
  // wire INNER_B[6] ;
  // wire INNER_B[7] ;
  // wire INNER_B[8] ;
  // wire INNER_B[9] ;
  wire CARRYCASCIN;
  wire CARRYCASCOUT;
  wire CARRYIN;
  // wire INNER_CARRYINSEL[0] ;
  // wire INNER_CARRYINSEL[1] ;
  // wire INNER_CARRYINSEL[2] ;
  // wire INNER_CARRYOUT[0] ;
  // wire INNER_CARRYOUT[1] ;
  // wire INNER_CARRYOUT[2] ;
  // wire INNER_CARRYOUT[3] ;
  wire CEA1;
  wire CEA2;
  wire CEAD;
  wire CEALUMODE;
  wire CEB1;
  wire CEB2;
  wire CEC;
  wire CECARRYIN;
  wire CECTRL;
  wire CED;
  wire CEINMODE;
  wire CEM;
  wire CEP;
  wire CLK;
  // wire INNER_C[0] ;
  // wire INNER_C[10] ;
  // wire INNER_C[11] ;
  // wire INNER_C[12] ;
  // wire INNER_C[13] ;
  // wire INNER_C[14] ;
  // wire INNER_C[15] ;
  // wire INNER_C[16] ;
  // wire INNER_C[17] ;
  // wire INNER_C[18] ;
  // wire INNER_C[19] ;
  // wire INNER_C[1] ;
  // wire INNER_C[20] ;
  // wire INNER_C[21] ;
  // wire INNER_C[22] ;
  // wire INNER_C[23] ;
  // wire INNER_C[24] ;
  // wire INNER_C[25] ;
  // wire INNER_C[26] ;
  // wire INNER_C[27] ;
  // wire INNER_C[28] ;
  // wire INNER_C[29] ;
  // wire INNER_C[2] ;
  // wire INNER_C[30] ;
  // wire INNER_C[31] ;
  // wire INNER_C[32] ;
  // wire INNER_C[33] ;
  // wire INNER_C[34] ;
  // wire INNER_C[35] ;
  // wire INNER_C[36] ;
  // wire INNER_C[37] ;
  // wire INNER_C[38] ;
  // wire INNER_C[39] ;
  // wire INNER_C[3] ;
  // wire INNER_C[40] ;
  // wire INNER_C[41] ;
  // wire INNER_C[42] ;
  // wire INNER_C[43] ;
  // wire INNER_C[44] ;
  // wire INNER_C[45] ;
  // wire INNER_C[46] ;
  // wire INNER_C[47] ;
  // wire INNER_C[4] ;
  // wire INNER_C[5] ;
  // wire INNER_C[6] ;
  // wire INNER_C[7] ;
  // wire INNER_C[8] ;
  // wire INNER_C[9] ;
  wire INNER_DSP_ALU.ALUMODE10 ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_30_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_31_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_32_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_33_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_34_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_35_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_36_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_37_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_38_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_39_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_40_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_41_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_42_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_43_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_44_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_45_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_46_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_47_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.ALU_OUT_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.COUT_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.COUT_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.COUT_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.COUT_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.MULTSIGN_ALU ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_ALU.XOR_MX_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_30_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_31_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_32_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_33_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_34_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_35_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_36_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_37_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_38_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_39_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_40_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_41_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_42_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_43_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_44_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_45_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_46_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_47_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_C_DATA.C_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.AMULT26 ;
  wire INNER_DSP_MULTIPLIER.BMULT17 ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_30_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_31_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_32_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_33_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_34_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_35_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_36_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_37_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_38_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_39_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_40_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_41_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_42_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_43_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_44_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.U_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_30_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_31_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_32_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_33_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_34_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_35_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_36_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_37_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_38_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_39_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_40_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_41_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_42_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_43_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_44_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_MULTIPLIER.V_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_30_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_31_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_32_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_33_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_34_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_35_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_36_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_37_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_38_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_39_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_40_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_41_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_42_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_43_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_44_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.U_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_30_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_31_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_32_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_33_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_34_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_35_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_36_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_37_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_38_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_39_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_40_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_41_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_42_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_43_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_44_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_M_DATA.V_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.CCOUT_FB ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_27_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_28_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_29_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_30_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_31_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_32_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_33_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_34_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_35_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_36_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_37_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_38_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_39_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_40_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_41_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_42_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_43_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_44_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_45_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_46_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_47_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_OUTPUT.P_FDBK_47 ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD.AD_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.ADDSUB ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_9_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.INMODE_2 ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_0_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_10_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_11_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_12_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_13_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_14_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_15_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_16_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_17_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_18_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_19_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_1_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_20_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_21_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_22_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_23_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_24_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_25_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_26_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_2_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_3_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_4_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_5_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_6_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_7_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_8_ANG_CLOSE_ ;
  wire INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_9_ANG_CLOSE_ ;
  // wire INNER_D[0] ;
  // wire INNER_D[10] ;
  // wire INNER_D[11] ;
  // wire INNER_D[12] ;
  // wire INNER_D[13] ;
  // wire INNER_D[14] ;
  // wire INNER_D[15] ;
  // wire INNER_D[16] ;
  // wire INNER_D[17] ;
  // wire INNER_D[18] ;
  // wire INNER_D[19] ;
  // wire INNER_D[1] ;
  // wire INNER_D[20] ;
  // wire INNER_D[21] ;
  // wire INNER_D[22] ;
  // wire INNER_D[23] ;
  // wire INNER_D[24] ;
  // wire INNER_D[25] ;
  // wire INNER_D[26] ;
  // wire INNER_D[2] ;
  // wire INNER_D[3] ;
  // wire INNER_D[4] ;
  // wire INNER_D[5] ;
  // wire INNER_D[6] ;
  // wire INNER_D[7] ;
  // wire INNER_D[8] ;
  // wire INNER_D[9] ;
  // wire INNER_INMODE[0] ;
  // wire INNER_INMODE[1] ;
  // wire INNER_INMODE[2] ;
  // wire INNER_INMODE[3] ;
  // wire INNER_INMODE[4] ;
  wire MULTSIGNIN;
  wire MULTSIGNOUT;
  // wire INNER_OPMODE[0] ;
  // wire INNER_OPMODE[1] ;
  // wire INNER_OPMODE[2] ;
  // wire INNER_OPMODE[3] ;
  // wire INNER_OPMODE[4] ;
  // wire INNER_OPMODE[5] ;
  // wire INNER_OPMODE[6] ;
  // wire INNER_OPMODE[7] ;
  // wire INNER_OPMODE[8] ;
  wire OVERFLOW;
  wire PATTERNBDETECT;
  wire PATTERNDETECT;
  // wire INNER_PCIN[0] ;
  // wire INNER_PCIN[10] ;
  // wire INNER_PCIN[11] ;
  // wire INNER_PCIN[12] ;
  // wire INNER_PCIN[13] ;
  // wire INNER_PCIN[14] ;
  // wire INNER_PCIN[15] ;
  // wire INNER_PCIN[16] ;
  // wire INNER_PCIN[17] ;
  // wire INNER_PCIN[18] ;
  // wire INNER_PCIN[19] ;
  // wire INNER_PCIN[1] ;
  // wire INNER_PCIN[20] ;
  // wire INNER_PCIN[21] ;
  // wire INNER_PCIN[22] ;
  // wire INNER_PCIN[23] ;
  // wire INNER_PCIN[24] ;
  // wire INNER_PCIN[25] ;
  // wire INNER_PCIN[26] ;
  // wire INNER_PCIN[27] ;
  // wire INNER_PCIN[28] ;
  // wire INNER_PCIN[29] ;
  // wire INNER_PCIN[2] ;
  // wire INNER_PCIN[30] ;
  // wire INNER_PCIN[31] ;
  // wire INNER_PCIN[32] ;
  // wire INNER_PCIN[33] ;
  // wire INNER_PCIN[34] ;
  // wire INNER_PCIN[35] ;
  // wire INNER_PCIN[36] ;
  // wire INNER_PCIN[37] ;
  // wire INNER_PCIN[38] ;
  // wire INNER_PCIN[39] ;
  // wire INNER_PCIN[3] ;
  // wire INNER_PCIN[40] ;
  // wire INNER_PCIN[41] ;
  // wire INNER_PCIN[42] ;
  // wire INNER_PCIN[43] ;
  // wire INNER_PCIN[44] ;
  // wire INNER_PCIN[45] ;
  // wire INNER_PCIN[46] ;
  // wire INNER_PCIN[47] ;
  // wire INNER_PCIN[4] ;
  // wire INNER_PCIN[5] ;
  // wire INNER_PCIN[6] ;
  // wire INNER_PCIN[7] ;
  // wire INNER_PCIN[8] ;
  // wire INNER_PCIN[9] ;
  // wire INNER_PCOUT[0] ;
  // wire INNER_PCOUT[10] ;
  // wire INNER_PCOUT[11] ;
  // wire INNER_PCOUT[12] ;
  // wire INNER_PCOUT[13] ;
  // wire INNER_PCOUT[14] ;
  // wire INNER_PCOUT[15] ;
  // wire INNER_PCOUT[16] ;
  // wire INNER_PCOUT[17] ;
  // wire INNER_PCOUT[18] ;
  // wire INNER_PCOUT[19] ;
  // wire INNER_PCOUT[1] ;
  // wire INNER_PCOUT[20] ;
  // wire INNER_PCOUT[21] ;
  // wire INNER_PCOUT[22] ;
  // wire INNER_PCOUT[23] ;
  // wire INNER_PCOUT[24] ;
  // wire INNER_PCOUT[25] ;
  // wire INNER_PCOUT[26] ;
  // wire INNER_PCOUT[27] ;
  // wire INNER_PCOUT[28] ;
  // wire INNER_PCOUT[29] ;
  // wire INNER_PCOUT[2] ;
  // wire INNER_PCOUT[30] ;
  // wire INNER_PCOUT[31] ;
  // wire INNER_PCOUT[32] ;
  // wire INNER_PCOUT[33] ;
  // wire INNER_PCOUT[34] ;
  // wire INNER_PCOUT[35] ;
  // wire INNER_PCOUT[36] ;
  // wire INNER_PCOUT[37] ;
  // wire INNER_PCOUT[38] ;
  // wire INNER_PCOUT[39] ;
  // wire INNER_PCOUT[3] ;
  // wire INNER_PCOUT[40] ;
  // wire INNER_PCOUT[41] ;
  // wire INNER_PCOUT[42] ;
  // wire INNER_PCOUT[43] ;
  // wire INNER_PCOUT[44] ;
  // wire INNER_PCOUT[45] ;
  // wire INNER_PCOUT[46] ;
  // wire INNER_PCOUT[47] ;
  // wire INNER_PCOUT[4] ;
  // wire INNER_PCOUT[5] ;
  // wire INNER_PCOUT[6] ;
  // wire INNER_PCOUT[7] ;
  // wire INNER_PCOUT[8] ;
  // wire INNER_PCOUT[9] ;
  // wire INNER_P[0] ;
  // wire INNER_P[10] ;
  // wire INNER_P[11] ;
  // wire INNER_P[12] ;
  // wire INNER_P[13] ;
  // wire INNER_P[14] ;
  // wire INNER_P[15] ;
  // wire INNER_P[16] ;
  // wire INNER_P[17] ;
  // wire INNER_P[18] ;
  // wire INNER_P[19] ;
  // wire INNER_P[1] ;
  // wire INNER_P[20] ;
  // wire INNER_P[21] ;
  // wire INNER_P[22] ;
  // wire INNER_P[23] ;
  // wire INNER_P[24] ;
  // wire INNER_P[25] ;
  // wire INNER_P[26] ;
  // wire INNER_P[27] ;
  // wire INNER_P[28] ;
  // wire INNER_P[29] ;
  // wire INNER_P[2] ;
  // wire INNER_P[30] ;
  // wire INNER_P[31] ;
  // wire INNER_P[32] ;
  // wire INNER_P[33] ;
  // wire INNER_P[34] ;
  // wire INNER_P[35] ;
  // wire INNER_P[36] ;
  // wire INNER_P[37] ;
  // wire INNER_P[38] ;
  // wire INNER_P[39] ;
  // wire INNER_P[3] ;
  // wire INNER_P[40] ;
  // wire INNER_P[41] ;
  // wire INNER_P[42] ;
  // wire INNER_P[43] ;
  // wire INNER_P[44] ;
  // wire INNER_P[45] ;
  // wire INNER_P[46] ;
  // wire INNER_P[47] ;
  // wire INNER_P[4] ;
  // wire INNER_P[5] ;
  // wire INNER_P[6] ;
  // wire INNER_P[7] ;
  // wire INNER_P[8] ;
  // wire INNER_P[9] ;
  wire RSTA;
  wire RSTALLCARRYIN;
  wire RSTALUMODE;
  wire RSTB;
  wire RSTC;
  wire RSTCTRL;
  wire RSTD;
  wire RSTINMODE;
  wire RSTM;
  wire RSTP;
  wire UNDERFLOW;
  // wire INNER_XOROUT[0] ;
  // wire INNER_XOROUT[1] ;
  // wire INNER_XOROUT[2] ;
  // wire INNER_XOROUT[3] ;
  // wire INNER_XOROUT[4] ;
  // wire INNER_XOROUT[5] ;
  // wire INNER_XOROUT[6] ;
  // wire INNER_XOROUT[7] ;

  DSP_ALU DSP_ALU_INST
       (.ALUMODE({INNER_ALUMODE[3] ,INNER_ALUMODE[2] ,INNER_ALUMODE[1] ,INNER_ALUMODE[0] }),
        .ALUMODE10(INNER_DSP_ALU.ALUMODE10 ),
        .ALU_OUT({INNER_DSP_ALU.ALU_OUT_ANG_OPEN_47_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_46_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_45_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_0_ANG_CLOSE_ }),
        .AMULT26(INNER_DSP_MULTIPLIER.AMULT26 ),
        .A_ALU({INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_0_ANG_CLOSE_ }),
        .BMULT17(INNER_DSP_MULTIPLIER.BMULT17 ),
        .B_ALU({INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_0_ANG_CLOSE_ }),
        .CARRYCASCIN(CARRYCASCIN),
        .CARRYIN(CARRYIN),
        .CARRYINSEL({INNER_CARRYINSEL[2] ,INNER_CARRYINSEL[1] ,INNER_CARRYINSEL[0] }),
        .CCOUT(INNER_DSP_OUTPUT.CCOUT_FB ),
        .CEALUMODE(CEALUMODE),
        .CECARRYIN(CECARRYIN),
        .CECTRL(CECTRL),
        .CEM(CEM),
        .CLK(CLK),
        .COUT({INNER_DSP_ALU.COUT_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_ALU.COUT_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_ALU.COUT_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_ALU.COUT_ANG_OPEN_0_ANG_CLOSE_ }),
        .C_DATA({INNER_DSP_C_DATA.C_DATA_ANG_OPEN_47_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_46_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_45_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .MULTSIGNIN(MULTSIGNIN),
        .MULTSIGN_ALU(INNER_DSP_ALU.MULTSIGN_ALU ),
        .OPMODE({INNER_OPMODE[8] ,INNER_OPMODE[7] ,INNER_OPMODE[6] ,INNER_OPMODE[5] ,INNER_OPMODE[4] ,INNER_OPMODE[3] ,INNER_OPMODE[2] ,INNER_OPMODE[1] ,INNER_OPMODE[0] }),
        .PCIN({INNER_PCIN[47] ,INNER_PCIN[46] ,INNER_PCIN[45] ,INNER_PCIN[44] ,INNER_PCIN[43] ,INNER_PCIN[42] ,INNER_PCIN[41] ,INNER_PCIN[40] ,INNER_PCIN[39] ,INNER_PCIN[38] ,INNER_PCIN[37] ,INNER_PCIN[36] ,INNER_PCIN[35] ,INNER_PCIN[34] ,INNER_PCIN[33] ,INNER_PCIN[32] ,INNER_PCIN[31] ,INNER_PCIN[30] ,INNER_PCIN[29] ,INNER_PCIN[28] ,INNER_PCIN[27] ,INNER_PCIN[26] ,INNER_PCIN[25] ,INNER_PCIN[24] ,INNER_PCIN[23] ,INNER_PCIN[22] ,INNER_PCIN[21] ,INNER_PCIN[20] ,INNER_PCIN[19] ,INNER_PCIN[18] ,INNER_PCIN[17] ,INNER_PCIN[16] ,INNER_PCIN[15] ,INNER_PCIN[14] ,INNER_PCIN[13] ,INNER_PCIN[12] ,INNER_PCIN[11] ,INNER_PCIN[10] ,INNER_PCIN[9] ,INNER_PCIN[8] ,INNER_PCIN[7] ,INNER_PCIN[6] ,INNER_PCIN[5] ,INNER_PCIN[4] ,INNER_PCIN[3] ,INNER_PCIN[2] ,INNER_PCIN[1] ,INNER_PCIN[0] }),
        .P_FDBK({INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_47_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_46_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_45_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_0_ANG_CLOSE_ }),
        .P_FDBK_47(INNER_DSP_OUTPUT.P_FDBK_47 ),
        .RSTALLCARRYIN(RSTALLCARRYIN),
        .RSTALUMODE(RSTALUMODE),
        .RSTCTRL(RSTCTRL),
        .U_DATA({INNER_DSP_M_DATA.U_DATA_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .V_DATA({INNER_DSP_M_DATA.V_DATA_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .XOR_MX({INNER_DSP_ALU.XOR_MX_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_0_ANG_CLOSE_ }));
  DSP_A_B_DATA DSP_A_B_DATA_INST
       (.A({INNER_A[29] ,INNER_A[28] ,INNER_A[27] ,INNER_A[26] ,INNER_A[25] ,INNER_A[24] ,INNER_A[23] ,INNER_A[22] ,INNER_A[21] ,INNER_A[20] ,INNER_A[19] ,INNER_A[18] ,INNER_A[17] ,INNER_A[16] ,INNER_A[15] ,INNER_A[14] ,INNER_A[13] ,INNER_A[12] ,INNER_A[11] ,INNER_A[10] ,INNER_A[9] ,INNER_A[8] ,INNER_A[7] ,INNER_A[6] ,INNER_A[5] ,INNER_A[4] ,INNER_A[3] ,INNER_A[2] ,INNER_A[1] ,INNER_A[0] }),
        .A1_DATA({INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .A2_DATA({INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .ACIN({INNER_ACIN[29] ,INNER_ACIN[28] ,INNER_ACIN[27] ,INNER_ACIN[26] ,INNER_ACIN[25] ,INNER_ACIN[24] ,INNER_ACIN[23] ,INNER_ACIN[22] ,INNER_ACIN[21] ,INNER_ACIN[20] ,INNER_ACIN[19] ,INNER_ACIN[18] ,INNER_ACIN[17] ,INNER_ACIN[16] ,INNER_ACIN[15] ,INNER_ACIN[14] ,INNER_ACIN[13] ,INNER_ACIN[12] ,INNER_ACIN[11] ,INNER_ACIN[10] ,INNER_ACIN[9] ,INNER_ACIN[8] ,INNER_ACIN[7] ,INNER_ACIN[6] ,INNER_ACIN[5] ,INNER_ACIN[4] ,INNER_ACIN[3] ,INNER_ACIN[2] ,INNER_ACIN[1] ,INNER_ACIN[0] }),
        .ACOUT({INNER_ACOUT[29] ,INNER_ACOUT[28] ,INNER_ACOUT[27] ,INNER_ACOUT[26] ,INNER_ACOUT[25] ,INNER_ACOUT[24] ,INNER_ACOUT[23] ,INNER_ACOUT[22] ,INNER_ACOUT[21] ,INNER_ACOUT[20] ,INNER_ACOUT[19] ,INNER_ACOUT[18] ,INNER_ACOUT[17] ,INNER_ACOUT[16] ,INNER_ACOUT[15] ,INNER_ACOUT[14] ,INNER_ACOUT[13] ,INNER_ACOUT[12] ,INNER_ACOUT[11] ,INNER_ACOUT[10] ,INNER_ACOUT[9] ,INNER_ACOUT[8] ,INNER_ACOUT[7] ,INNER_ACOUT[6] ,INNER_ACOUT[5] ,INNER_ACOUT[4] ,INNER_ACOUT[3] ,INNER_ACOUT[2] ,INNER_ACOUT[1] ,INNER_ACOUT[0] }),
        .A_ALU({INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A_ALU_ANG_OPEN_0_ANG_CLOSE_ }),
        .B({INNER_B[17] ,INNER_B[16] ,INNER_B[15] ,INNER_B[14] ,INNER_B[13] ,INNER_B[12] ,INNER_B[11] ,INNER_B[10] ,INNER_B[9] ,INNER_B[8] ,INNER_B[7] ,INNER_B[6] ,INNER_B[5] ,INNER_B[4] ,INNER_B[3] ,INNER_B[2] ,INNER_B[1] ,INNER_B[0] }),
        .B1_DATA({INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .B2_DATA({INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .BCIN({INNER_BCIN[17] ,INNER_BCIN[16] ,INNER_BCIN[15] ,INNER_BCIN[14] ,INNER_BCIN[13] ,INNER_BCIN[12] ,INNER_BCIN[11] ,INNER_BCIN[10] ,INNER_BCIN[9] ,INNER_BCIN[8] ,INNER_BCIN[7] ,INNER_BCIN[6] ,INNER_BCIN[5] ,INNER_BCIN[4] ,INNER_BCIN[3] ,INNER_BCIN[2] ,INNER_BCIN[1] ,INNER_BCIN[0] }),
        .BCOUT({INNER_BCOUT[17] ,INNER_BCOUT[16] ,INNER_BCOUT[15] ,INNER_BCOUT[14] ,INNER_BCOUT[13] ,INNER_BCOUT[12] ,INNER_BCOUT[11] ,INNER_BCOUT[10] ,INNER_BCOUT[9] ,INNER_BCOUT[8] ,INNER_BCOUT[7] ,INNER_BCOUT[6] ,INNER_BCOUT[5] ,INNER_BCOUT[4] ,INNER_BCOUT[3] ,INNER_BCOUT[2] ,INNER_BCOUT[1] ,INNER_BCOUT[0] }),
        .B_ALU({INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B_ALU_ANG_OPEN_0_ANG_CLOSE_ }),
        .CEA1(CEA1),
        .CEA2(CEA2),
        .CEB1(CEB1),
        .CEB2(CEB2),
        .CLK(CLK),
        .RSTA(RSTA),
        .RSTB(RSTB));
  DSP_C_DATA DSP_C_DATA_INST
       (.C({INNER_C[47] ,INNER_C[46] ,INNER_C[45] ,INNER_C[44] ,INNER_C[43] ,INNER_C[42] ,INNER_C[41] ,INNER_C[40] ,INNER_C[39] ,INNER_C[38] ,INNER_C[37] ,INNER_C[36] ,INNER_C[35] ,INNER_C[34] ,INNER_C[33] ,INNER_C[32] ,INNER_C[31] ,INNER_C[30] ,INNER_C[29] ,INNER_C[28] ,INNER_C[27] ,INNER_C[26] ,INNER_C[25] ,INNER_C[24] ,INNER_C[23] ,INNER_C[22] ,INNER_C[21] ,INNER_C[20] ,INNER_C[19] ,INNER_C[18] ,INNER_C[17] ,INNER_C[16] ,INNER_C[15] ,INNER_C[14] ,INNER_C[13] ,INNER_C[12] ,INNER_C[11] ,INNER_C[10] ,INNER_C[9] ,INNER_C[8] ,INNER_C[7] ,INNER_C[6] ,INNER_C[5] ,INNER_C[4] ,INNER_C[3] ,INNER_C[2] ,INNER_C[1] ,INNER_C[0] }),
        .CEC(CEC),
        .CLK(CLK),
        .C_DATA({INNER_DSP_C_DATA.C_DATA_ANG_OPEN_47_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_46_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_45_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .RSTC(RSTC));
  DSP_MULTIPLIER DSP_MULTIPLIER_INST
       (.A2A1({INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_0_ANG_CLOSE_ }),
        .AD_DATA({INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .AMULT26(INNER_DSP_MULTIPLIER.AMULT26 ),
        .B2B1({INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_0_ANG_CLOSE_ }),
        .BMULT17(INNER_DSP_MULTIPLIER.BMULT17 ),
        .U({INNER_DSP_MULTIPLIER.U_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_0_ANG_CLOSE_ }),
        .V({INNER_DSP_MULTIPLIER.V_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_0_ANG_CLOSE_ }));
  DSP_M_DATA DSP_M_DATA_INST
       (.CEM(CEM),
        .CLK(CLK),
        .RSTM(RSTM),
        .U({INNER_DSP_MULTIPLIER.U_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.U_ANG_OPEN_0_ANG_CLOSE_ }),
        .U_DATA({INNER_DSP_M_DATA.U_DATA_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_M_DATA.U_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .V({INNER_DSP_MULTIPLIER.V_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_MULTIPLIER.V_ANG_OPEN_0_ANG_CLOSE_ }),
        .V_DATA({INNER_DSP_M_DATA.V_DATA_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_M_DATA.V_DATA_ANG_OPEN_0_ANG_CLOSE_ }));
  DSP_OUTPUT DSP_OUTPUT_INST
       (.ALUMODE10(INNER_DSP_ALU.ALUMODE10 ),
        .ALU_OUT({INNER_DSP_ALU.ALU_OUT_ANG_OPEN_47_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_46_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_45_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_ALU.ALU_OUT_ANG_OPEN_0_ANG_CLOSE_ }),
        .CARRYCASCOUT(CARRYCASCOUT),
        .CARRYOUT({INNER_CARRYOUT[3] ,INNER_CARRYOUT[2] ,INNER_CARRYOUT[1] ,INNER_CARRYOUT[0] }),
        .CCOUT_FB(INNER_DSP_OUTPUT.CCOUT_FB ),
        .CEP(CEP),
        .CLK(CLK),
        .COUT({INNER_DSP_ALU.COUT_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_ALU.COUT_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_ALU.COUT_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_ALU.COUT_ANG_OPEN_0_ANG_CLOSE_ }),
        .C_DATA({INNER_DSP_C_DATA.C_DATA_ANG_OPEN_47_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_46_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_45_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_C_DATA.C_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .MULTSIGNOUT(MULTSIGNOUT),
        .MULTSIGN_ALU(INNER_DSP_ALU.MULTSIGN_ALU ),
        .OVERFLOW(OVERFLOW),
        .P({INNER_P[47] ,INNER_P[46] ,INNER_P[45] ,INNER_P[44] ,INNER_P[43] ,INNER_P[42] ,INNER_P[41] ,INNER_P[40] ,INNER_P[39] ,INNER_P[38] ,INNER_P[37] ,INNER_P[36] ,INNER_P[35] ,INNER_P[34] ,INNER_P[33] ,INNER_P[32] ,INNER_P[31] ,INNER_P[30] ,INNER_P[29] ,INNER_P[28] ,INNER_P[27] ,INNER_P[26] ,INNER_P[25] ,INNER_P[24] ,INNER_P[23] ,INNER_P[22] ,INNER_P[21] ,INNER_P[20] ,INNER_P[19] ,INNER_P[18] ,INNER_P[17] ,INNER_P[16] ,INNER_P[15] ,INNER_P[14] ,INNER_P[13] ,INNER_P[12] ,INNER_P[11] ,INNER_P[10] ,INNER_P[9] ,INNER_P[8] ,INNER_P[7] ,INNER_P[6] ,INNER_P[5] ,INNER_P[4] ,INNER_P[3] ,INNER_P[2] ,INNER_P[1] ,INNER_P[0] }),
        .PATTERN_B_DETECT(PATTERNBDETECT),
        .PATTERN_DETECT(PATTERNDETECT),
        .PCOUT({INNER_PCOUT[47] ,INNER_PCOUT[46] ,INNER_PCOUT[45] ,INNER_PCOUT[44] ,INNER_PCOUT[43] ,INNER_PCOUT[42] ,INNER_PCOUT[41] ,INNER_PCOUT[40] ,INNER_PCOUT[39] ,INNER_PCOUT[38] ,INNER_PCOUT[37] ,INNER_PCOUT[36] ,INNER_PCOUT[35] ,INNER_PCOUT[34] ,INNER_PCOUT[33] ,INNER_PCOUT[32] ,INNER_PCOUT[31] ,INNER_PCOUT[30] ,INNER_PCOUT[29] ,INNER_PCOUT[28] ,INNER_PCOUT[27] ,INNER_PCOUT[26] ,INNER_PCOUT[25] ,INNER_PCOUT[24] ,INNER_PCOUT[23] ,INNER_PCOUT[22] ,INNER_PCOUT[21] ,INNER_PCOUT[20] ,INNER_PCOUT[19] ,INNER_PCOUT[18] ,INNER_PCOUT[17] ,INNER_PCOUT[16] ,INNER_PCOUT[15] ,INNER_PCOUT[14] ,INNER_PCOUT[13] ,INNER_PCOUT[12] ,INNER_PCOUT[11] ,INNER_PCOUT[10] ,INNER_PCOUT[9] ,INNER_PCOUT[8] ,INNER_PCOUT[7] ,INNER_PCOUT[6] ,INNER_PCOUT[5] ,INNER_PCOUT[4] ,INNER_PCOUT[3] ,INNER_PCOUT[2] ,INNER_PCOUT[1] ,INNER_PCOUT[0] }),
        .P_FDBK({INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_47_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_46_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_45_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_44_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_43_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_42_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_41_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_40_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_39_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_38_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_37_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_36_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_35_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_34_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_33_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_32_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_31_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_30_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_29_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_28_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_27_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_OUTPUT.P_FDBK_ANG_OPEN_0_ANG_CLOSE_ }),
        .P_FDBK_47(INNER_DSP_OUTPUT.P_FDBK_47 ),
        .RSTP(RSTP),
        .UNDERFLOW(UNDERFLOW),
        .XOROUT({INNER_XOROUT[7] ,INNER_XOROUT[6] ,INNER_XOROUT[5] ,INNER_XOROUT[4] ,INNER_XOROUT[3] ,INNER_XOROUT[2] ,INNER_XOROUT[1] ,INNER_XOROUT[0] }),
        .XOR_MX({INNER_DSP_ALU.XOR_MX_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_ALU.XOR_MX_ANG_OPEN_0_ANG_CLOSE_ }));
  DSP_PREADD_DATA DSP_PREADD_DATA_INST
       (.A1_DATA({INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A1_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .A2A1({INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.A2A1_ANG_OPEN_0_ANG_CLOSE_ }),
        .A2_DATA({INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.A2_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .AD({INNER_DSP_PREADD.AD_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_0_ANG_CLOSE_ }),
        .ADDSUB(INNER_DSP_PREADD_DATA.ADDSUB ),
        .AD_DATA({INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.AD_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .B1_DATA({INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B1_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .B2B1({INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.B2B1_ANG_OPEN_0_ANG_CLOSE_ }),
        .B2_DATA({INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_A_B_DATA.B2_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .CEAD(CEAD),
        .CED(CED),
        .CEINMODE(CEINMODE),
        .CLK(CLK),
        .DIN({INNER_D[26] ,INNER_D[25] ,INNER_D[24] ,INNER_D[23] ,INNER_D[22] ,INNER_D[21] ,INNER_D[20] ,INNER_D[19] ,INNER_D[18] ,INNER_D[17] ,INNER_D[16] ,INNER_D[15] ,INNER_D[14] ,INNER_D[13] ,INNER_D[12] ,INNER_D[11] ,INNER_D[10] ,INNER_D[9] ,INNER_D[8] ,INNER_D[7] ,INNER_D[6] ,INNER_D[5] ,INNER_D[4] ,INNER_D[3] ,INNER_D[2] ,INNER_D[1] ,INNER_D[0] }),
        .D_DATA({INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .INMODE({INNER_INMODE[4] ,INNER_INMODE[3] ,INNER_INMODE[2] ,INNER_INMODE[1] ,INNER_INMODE[0] }),
        .INMODE_2(INNER_DSP_PREADD_DATA.INMODE_2 ),
        .PREADD_AB({INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_0_ANG_CLOSE_ }),
        .RSTD(RSTD),
        .RSTINMODE(RSTINMODE));
  DSP_PREADD DSP_PREADD_INST
       (.AD({INNER_DSP_PREADD.AD_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD.AD_ANG_OPEN_0_ANG_CLOSE_ }),
        .ADDSUB(INNER_DSP_PREADD_DATA.ADDSUB ),
        .D_DATA({INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.D_DATA_ANG_OPEN_0_ANG_CLOSE_ }),
        .INMODE2(INNER_DSP_PREADD_DATA.INMODE_2 ),
        .PREADD_AB({INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_26_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_25_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_24_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_23_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_22_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_21_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_20_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_19_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_18_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_17_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_16_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_15_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_14_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_13_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_12_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_11_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_10_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_9_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_8_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_7_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_6_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_5_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_4_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_3_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_2_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_1_ANG_CLOSE_ ,INNER_DSP_PREADD_DATA.PREADD_AB_ANG_OPEN_0_ANG_CLOSE_ }));
endmodule // DSP48E2

module RAM32M
  #(parameter INIT_A = 64'h0000000000000000,
    parameter INIT_B = 64'h0000000000000000,
    parameter INIT_C = 64'h0000000000000000,
    parameter INIT_D = 64'h0000000000000000,
    parameter IS_WCLK_INVERTED = 1'b0)
    
  (DOA,
   DOB,
   DOC,
   DOD,
   ADDRA,
   ADDRB,
   ADDRC,
   ADDRD,
   DIA,
   DIB,
   DIC,
   DID,
   WCLK,
   WE);
   input WCLK;
   input WE;
   
   input [4:0] ADDRA;
   input [4:0] ADDRB;
   input [4:0] ADDRC;
   input [4:0] ADDRD;
   wire	 ADDRA0;
   wire	 ADDRA1;
   wire	 ADDRA2;
   wire	 ADDRA3;
   wire	 ADDRA4;
   wire	 ADDRB0;
   wire	 ADDRB1;
   wire	 ADDRB2;
   wire	 ADDRB3;
   wire	 ADDRB4;
   wire	 ADDRC0;
   wire	 ADDRC1;
   wire	 ADDRC2;
   wire	 ADDRC3;
   wire	 ADDRC4;
   wire	 ADDRD0;
   wire	 ADDRD1;
   wire	 ADDRD2;
   wire	 ADDRD3;
   wire	 ADDRD4;
   assign ADDRA0 = ADDRA[0];
   assign ADDRA1 = ADDRA[1];
   assign ADDRA2 = ADDRA[2];
   assign ADDRA3 = ADDRA[3];
   assign ADDRA4 = ADDRA[4];
   assign ADDRB0 = ADDRB[0];
   assign ADDRB1 = ADDRB[1];
   assign ADDRB2 = ADDRB[2];
   assign ADDRB3 = ADDRB[3];
   assign ADDRB4 = ADDRB[4];
   assign ADDRC0 = ADDRC[0];
   assign ADDRC1 = ADDRC[1];
   assign ADDRC2 = ADDRC[2];
   assign ADDRC3 = ADDRC[3];
   assign ADDRC4 = ADDRC[4];
   assign ADDRD0 = ADDRD[0];
   assign ADDRD1 = ADDRD[1];
   assign ADDRD2 = ADDRD[2];
   assign ADDRD3 = ADDRD[3];
   assign ADDRD4 = ADDRD[4];

   input [1:0] DIA;
   input [1:0] DIB;
   input [1:0] DIC;
   input [1:0] DID;
   wire	  DIA0;
   wire	  DIA1;
   wire	  DIB0;
   wire	  DIB1;
   wire	  DIC0;
   wire	  DIC1;
   wire	  DID0;
   wire	  DID1;
   assign DIA0 = DIA[0];
   assign DIA1 = DIA[1];
   assign DIB0 = DIB[0];
   assign DIB1 = DIB[1];
   assign DIC0 = DIC[0];
   assign DIC1 = DIC[1];
   assign DID0 = DID[0];
   assign DID1 = DID[1];
   
   output [1:0] DOA;
   output [1:0] DOB;
   output [1:0] DOC;
   output [1:0] DOD;
   wire	  DOA0;
   wire	  DOA1;
   wire	  DOB0;
   wire	  DOB1;
   wire	  DOC0;
   wire	  DOC1;
   wire	  DOD0;
   wire	  DOD1;
   assign DOA[0] = DOA0;
   assign DOA[1] = DOA1;
   assign DOB[0] = DOB0;
   assign DOB[1] = DOB1;
   assign DOC[0] = DOC0;
   assign DOC[1] = DOC1;
   assign DOD[0] = DOD0;
   assign DOD[1] = DOD1;
   
  wire WCLK;
  wire WE;

   RAMD32 RAMA
       (.CLK(WCLK),
        .I(DIA0),
        .O(DOA0),
        .RADR0(ADDRA0),
        .RADR1(ADDRA1),
        .RADR2(ADDRA2),
        .RADR3(ADDRA3),
        .RADR4(ADDRA4),
        .WADR0(ADDRD0),
        .WADR1(ADDRD1),
        .WADR2(ADDRD2),
        .WADR3(ADDRD3),
        .WADR4(ADDRD4),
        .WE(WE));
  RAMD32 RAMA_D1
       (.CLK(WCLK),
        .I(DIA1),
        .O(DOA1),
        .RADR0(ADDRA0),
        .RADR1(ADDRA1),
        .RADR2(ADDRA2),
        .RADR3(ADDRA3),
        .RADR4(ADDRA4),
        .WADR0(ADDRD0),
        .WADR1(ADDRD1),
        .WADR2(ADDRD2),
        .WADR3(ADDRD3),
        .WADR4(ADDRD4),
        .WE(WE));
  RAMD32 RAMB
       (.CLK(WCLK),
        .I(DIB0),
        .O(DOB0),
        .RADR0(ADDRB0),
        .RADR1(ADDRB1),
        .RADR2(ADDRB2),
        .RADR3(ADDRB3),
        .RADR4(ADDRB4),
        .WADR0(ADDRD0),
        .WADR1(ADDRD1),
        .WADR2(ADDRD2),
        .WADR3(ADDRD3),
        .WADR4(ADDRD4),
        .WE(WE));
  RAMD32 RAMB_D1
       (.CLK(WCLK),
        .I(DIB1),
        .O(DOB1),
        .RADR0(ADDRB0),
        .RADR1(ADDRB1),
        .RADR2(ADDRB2),
        .RADR3(ADDRB3),
        .RADR4(ADDRB4),
        .WADR0(ADDRD0),
        .WADR1(ADDRD1),
        .WADR2(ADDRD2),
        .WADR3(ADDRD3),
        .WADR4(ADDRD4),
        .WE(WE));
  RAMD32 RAMC
       (.CLK(WCLK),
        .I(DIC0),
        .O(DOC0),
        .RADR0(ADDRC0),
        .RADR1(ADDRC1),
        .RADR2(ADDRC2),
        .RADR3(ADDRC3),
        .RADR4(ADDRC4),
        .WADR0(ADDRD0),
        .WADR1(ADDRD1),
        .WADR2(ADDRD2),
        .WADR3(ADDRD3),
        .WADR4(ADDRD4),
        .WE(WE));
  RAMD32 RAMC_D1
       (.CLK(WCLK),
        .I(DIC1),
        .O(DOC1),
        .RADR0(ADDRC0),
        .RADR1(ADDRC1),
        .RADR2(ADDRC2),
        .RADR3(ADDRC3),
        .RADR4(ADDRC4),
        .WADR0(ADDRD0),
        .WADR1(ADDRD1),
        .WADR2(ADDRD2),
        .WADR3(ADDRD3),
        .WADR4(ADDRD4),
        .WE(WE));
  RAMS32 RAMD
       (.ADR0(ADDRD0),
        .ADR1(ADDRD1),
        .ADR2(ADDRD2),
        .ADR3(ADDRD3),
        .ADR4(ADDRD4),
        .CLK(WCLK),
        .I(DID0),
        .O(DOD0),
        .WE(WE));
  RAMS32 RAMD_D1
       (.ADR0(ADDRD0),
        .ADR1(ADDRD1),
        .ADR2(ADDRD2),
        .ADR3(ADDRD3),
        .ADR4(ADDRD4),
        .CLK(WCLK),
        .I(DID1),
        .O(DOD1),
        .WE(WE));
endmodule // RAM32M

