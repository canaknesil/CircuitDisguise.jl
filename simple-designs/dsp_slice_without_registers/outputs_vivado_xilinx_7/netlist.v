// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Tue Aug  8 11:09:11 2023
// Host        : DESKTOP-A95ADKL running 64-bit major release  (build 9200)
// Command     : write_verilog -mode design
//               C:/Users/canpi/Documents/repositories/circuit-disguise/designs/dsp_slice_without_registers/xilinx_netlist.v
// Design      : dsp_slice
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "5c348b6" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module dsp_slice
   (clk,
    reset);
  input clk;
  input reset;

  wire \<const0> ;
  wire \<const1> ;
  (* DONT_TOUCH *) wire [29:0]A;
  (* DONT_TOUCH *) wire [17:0]B;
  (* DONT_TOUCH *) wire [47:0]C;
  (* DONT_TOUCH *) wire [47:0]P;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire reset;
  wire reset_IBUF;

  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  (* box_type = "PRIMITIVE" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(0),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(0),
    .INMODEREG(0),
    .IS_ALUMODE_INVERTED(4'b0000),
    .IS_CARRYIN_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_INMODE_INVERTED(5'b00000),
    .IS_OPMODE_INVERTED(7'b0000000),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    DSP48E1_inst
       (.A(A),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const1> ,\<const1> ,\<const0> ,\<const0> }),
        .B(B),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C(C),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const1> ),
        .CEA2(\<const1> ),
        .CEAD(\<const1> ),
        .CEALUMODE(\<const1> ),
        .CEB1(\<const1> ),
        .CEB2(\<const1> ),
        .CEC(\<const1> ),
        .CECARRYIN(\<const1> ),
        .CECTRL(\<const1> ),
        .CED(\<const1> ),
        .CEINMODE(\<const1> ),
        .CEM(\<const1> ),
        .CEP(\<const1> ),
        .CLK(clk_IBUF_BUFG),
        .D({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .P(P),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(reset_IBUF),
        .RSTALLCARRYIN(reset_IBUF),
        .RSTALUMODE(reset_IBUF),
        .RSTB(reset_IBUF),
        .RSTC(reset_IBUF),
        .RSTCTRL(reset_IBUF),
        .RSTD(reset_IBUF),
        .RSTINMODE(reset_IBUF),
        .RSTM(reset_IBUF),
        .RSTP(reset_IBUF));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF #(
    .CCIO_EN("TRUE")) 
    clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  LUT1 #(
    .INIT(2'h2)) 
    i_0
       (.I0(\<const0> ),
        .O(A[29]));
  LUT1 #(
    .INIT(2'h2)) 
    i_1
       (.I0(\<const0> ),
        .O(A[28]));
  LUT1 #(
    .INIT(2'h2)) 
    i_10
       (.I0(\<const0> ),
        .O(A[19]));
  LUT1 #(
    .INIT(2'h2)) 
    i_11
       (.I0(\<const0> ),
        .O(A[18]));
  LUT1 #(
    .INIT(2'h2)) 
    i_12
       (.I0(\<const0> ),
        .O(A[17]));
  LUT1 #(
    .INIT(2'h2)) 
    i_13
       (.I0(\<const0> ),
        .O(A[16]));
  LUT1 #(
    .INIT(2'h2)) 
    i_14
       (.I0(\<const0> ),
        .O(A[15]));
  LUT1 #(
    .INIT(2'h2)) 
    i_15
       (.I0(\<const0> ),
        .O(A[14]));
  LUT1 #(
    .INIT(2'h2)) 
    i_16
       (.I0(\<const0> ),
        .O(A[13]));
  LUT1 #(
    .INIT(2'h2)) 
    i_17
       (.I0(\<const0> ),
        .O(A[12]));
  LUT1 #(
    .INIT(2'h2)) 
    i_18
       (.I0(\<const0> ),
        .O(A[11]));
  LUT1 #(
    .INIT(2'h2)) 
    i_19
       (.I0(\<const0> ),
        .O(A[10]));
  LUT1 #(
    .INIT(2'h2)) 
    i_2
       (.I0(\<const0> ),
        .O(A[27]));
  LUT1 #(
    .INIT(2'h2)) 
    i_20
       (.I0(\<const0> ),
        .O(A[9]));
  LUT1 #(
    .INIT(2'h2)) 
    i_21
       (.I0(\<const0> ),
        .O(A[8]));
  LUT1 #(
    .INIT(2'h2)) 
    i_22
       (.I0(\<const0> ),
        .O(A[7]));
  LUT1 #(
    .INIT(2'h2)) 
    i_23
       (.I0(\<const0> ),
        .O(A[6]));
  LUT1 #(
    .INIT(2'h2)) 
    i_24
       (.I0(\<const0> ),
        .O(A[5]));
  LUT1 #(
    .INIT(2'h2)) 
    i_25
       (.I0(\<const0> ),
        .O(A[4]));
  LUT1 #(
    .INIT(2'h2)) 
    i_26
       (.I0(\<const0> ),
        .O(A[3]));
  LUT1 #(
    .INIT(2'h2)) 
    i_27
       (.I0(\<const0> ),
        .O(A[2]));
  LUT1 #(
    .INIT(2'h2)) 
    i_28
       (.I0(\<const0> ),
        .O(A[1]));
  LUT1 #(
    .INIT(2'h2)) 
    i_29
       (.I0(\<const0> ),
        .O(A[0]));
  LUT1 #(
    .INIT(2'h2)) 
    i_3
       (.I0(\<const0> ),
        .O(A[26]));
  LUT1 #(
    .INIT(2'h2)) 
    i_30
       (.I0(\<const0> ),
        .O(B[17]));
  LUT1 #(
    .INIT(2'h2)) 
    i_31
       (.I0(\<const0> ),
        .O(B[16]));
  LUT1 #(
    .INIT(2'h2)) 
    i_32
       (.I0(\<const0> ),
        .O(B[15]));
  LUT1 #(
    .INIT(2'h2)) 
    i_33
       (.I0(\<const0> ),
        .O(B[14]));
  LUT1 #(
    .INIT(2'h2)) 
    i_34
       (.I0(\<const0> ),
        .O(B[13]));
  LUT1 #(
    .INIT(2'h2)) 
    i_35
       (.I0(\<const0> ),
        .O(B[12]));
  LUT1 #(
    .INIT(2'h2)) 
    i_36
       (.I0(\<const0> ),
        .O(B[11]));
  LUT1 #(
    .INIT(2'h2)) 
    i_37
       (.I0(\<const0> ),
        .O(B[10]));
  LUT1 #(
    .INIT(2'h2)) 
    i_38
       (.I0(\<const0> ),
        .O(B[9]));
  LUT1 #(
    .INIT(2'h2)) 
    i_39
       (.I0(\<const0> ),
        .O(B[8]));
  LUT1 #(
    .INIT(2'h2)) 
    i_4
       (.I0(\<const0> ),
        .O(A[25]));
  LUT1 #(
    .INIT(2'h2)) 
    i_40
       (.I0(\<const0> ),
        .O(B[7]));
  LUT1 #(
    .INIT(2'h2)) 
    i_41
       (.I0(\<const0> ),
        .O(B[6]));
  LUT1 #(
    .INIT(2'h2)) 
    i_42
       (.I0(\<const0> ),
        .O(B[5]));
  LUT1 #(
    .INIT(2'h2)) 
    i_43
       (.I0(\<const0> ),
        .O(B[4]));
  LUT1 #(
    .INIT(2'h2)) 
    i_44
       (.I0(\<const0> ),
        .O(B[3]));
  LUT1 #(
    .INIT(2'h2)) 
    i_45
       (.I0(\<const0> ),
        .O(B[2]));
  LUT1 #(
    .INIT(2'h2)) 
    i_46
       (.I0(\<const0> ),
        .O(B[1]));
  LUT1 #(
    .INIT(2'h2)) 
    i_47
       (.I0(\<const0> ),
        .O(B[0]));
  LUT1 #(
    .INIT(2'h2)) 
    i_48
       (.I0(\<const0> ),
        .O(C[47]));
  LUT1 #(
    .INIT(2'h2)) 
    i_49
       (.I0(\<const0> ),
        .O(C[46]));
  LUT1 #(
    .INIT(2'h2)) 
    i_5
       (.I0(\<const0> ),
        .O(A[24]));
  LUT1 #(
    .INIT(2'h2)) 
    i_50
       (.I0(\<const0> ),
        .O(C[45]));
  LUT1 #(
    .INIT(2'h2)) 
    i_51
       (.I0(\<const0> ),
        .O(C[44]));
  LUT1 #(
    .INIT(2'h2)) 
    i_52
       (.I0(\<const0> ),
        .O(C[43]));
  LUT1 #(
    .INIT(2'h2)) 
    i_53
       (.I0(\<const0> ),
        .O(C[42]));
  LUT1 #(
    .INIT(2'h2)) 
    i_54
       (.I0(\<const0> ),
        .O(C[41]));
  LUT1 #(
    .INIT(2'h2)) 
    i_55
       (.I0(\<const0> ),
        .O(C[40]));
  LUT1 #(
    .INIT(2'h2)) 
    i_56
       (.I0(\<const0> ),
        .O(C[39]));
  LUT1 #(
    .INIT(2'h2)) 
    i_57
       (.I0(\<const0> ),
        .O(C[38]));
  LUT1 #(
    .INIT(2'h2)) 
    i_58
       (.I0(\<const0> ),
        .O(C[37]));
  LUT1 #(
    .INIT(2'h2)) 
    i_59
       (.I0(\<const0> ),
        .O(C[36]));
  LUT1 #(
    .INIT(2'h2)) 
    i_6
       (.I0(\<const0> ),
        .O(A[23]));
  LUT1 #(
    .INIT(2'h2)) 
    i_60
       (.I0(\<const0> ),
        .O(C[35]));
  LUT1 #(
    .INIT(2'h2)) 
    i_61
       (.I0(\<const0> ),
        .O(C[34]));
  LUT1 #(
    .INIT(2'h2)) 
    i_62
       (.I0(\<const0> ),
        .O(C[33]));
  LUT1 #(
    .INIT(2'h2)) 
    i_63
       (.I0(\<const0> ),
        .O(C[32]));
  LUT1 #(
    .INIT(2'h2)) 
    i_64
       (.I0(\<const0> ),
        .O(C[31]));
  LUT1 #(
    .INIT(2'h2)) 
    i_65
       (.I0(\<const0> ),
        .O(C[30]));
  LUT1 #(
    .INIT(2'h2)) 
    i_66
       (.I0(\<const0> ),
        .O(C[29]));
  LUT1 #(
    .INIT(2'h2)) 
    i_67
       (.I0(\<const0> ),
        .O(C[28]));
  LUT1 #(
    .INIT(2'h2)) 
    i_68
       (.I0(\<const0> ),
        .O(C[27]));
  LUT1 #(
    .INIT(2'h2)) 
    i_69
       (.I0(\<const0> ),
        .O(C[26]));
  LUT1 #(
    .INIT(2'h2)) 
    i_7
       (.I0(\<const0> ),
        .O(A[22]));
  LUT1 #(
    .INIT(2'h2)) 
    i_70
       (.I0(\<const0> ),
        .O(C[25]));
  LUT1 #(
    .INIT(2'h2)) 
    i_71
       (.I0(\<const0> ),
        .O(C[24]));
  LUT1 #(
    .INIT(2'h2)) 
    i_72
       (.I0(\<const0> ),
        .O(C[23]));
  LUT1 #(
    .INIT(2'h2)) 
    i_73
       (.I0(\<const0> ),
        .O(C[22]));
  LUT1 #(
    .INIT(2'h2)) 
    i_74
       (.I0(\<const0> ),
        .O(C[21]));
  LUT1 #(
    .INIT(2'h2)) 
    i_75
       (.I0(\<const0> ),
        .O(C[20]));
  LUT1 #(
    .INIT(2'h2)) 
    i_76
       (.I0(\<const0> ),
        .O(C[19]));
  LUT1 #(
    .INIT(2'h2)) 
    i_77
       (.I0(\<const0> ),
        .O(C[18]));
  LUT1 #(
    .INIT(2'h2)) 
    i_78
       (.I0(\<const0> ),
        .O(C[17]));
  LUT1 #(
    .INIT(2'h2)) 
    i_79
       (.I0(\<const0> ),
        .O(C[16]));
  LUT1 #(
    .INIT(2'h2)) 
    i_8
       (.I0(\<const0> ),
        .O(A[21]));
  LUT1 #(
    .INIT(2'h2)) 
    i_80
       (.I0(\<const0> ),
        .O(C[15]));
  LUT1 #(
    .INIT(2'h2)) 
    i_81
       (.I0(\<const0> ),
        .O(C[14]));
  LUT1 #(
    .INIT(2'h2)) 
    i_82
       (.I0(\<const0> ),
        .O(C[13]));
  LUT1 #(
    .INIT(2'h2)) 
    i_83
       (.I0(\<const0> ),
        .O(C[12]));
  LUT1 #(
    .INIT(2'h2)) 
    i_84
       (.I0(\<const0> ),
        .O(C[11]));
  LUT1 #(
    .INIT(2'h2)) 
    i_85
       (.I0(\<const0> ),
        .O(C[10]));
  LUT1 #(
    .INIT(2'h2)) 
    i_86
       (.I0(\<const0> ),
        .O(C[9]));
  LUT1 #(
    .INIT(2'h2)) 
    i_87
       (.I0(\<const0> ),
        .O(C[8]));
  LUT1 #(
    .INIT(2'h2)) 
    i_88
       (.I0(\<const0> ),
        .O(C[7]));
  LUT1 #(
    .INIT(2'h2)) 
    i_89
       (.I0(\<const0> ),
        .O(C[6]));
  LUT1 #(
    .INIT(2'h2)) 
    i_9
       (.I0(\<const0> ),
        .O(A[20]));
  LUT1 #(
    .INIT(2'h2)) 
    i_90
       (.I0(\<const0> ),
        .O(C[5]));
  LUT1 #(
    .INIT(2'h2)) 
    i_91
       (.I0(\<const0> ),
        .O(C[4]));
  LUT1 #(
    .INIT(2'h2)) 
    i_92
       (.I0(\<const0> ),
        .O(C[3]));
  LUT1 #(
    .INIT(2'h2)) 
    i_93
       (.I0(\<const0> ),
        .O(C[2]));
  LUT1 #(
    .INIT(2'h2)) 
    i_94
       (.I0(\<const0> ),
        .O(C[1]));
  LUT1 #(
    .INIT(2'h2)) 
    i_95
       (.I0(\<const0> ),
        .O(C[0]));
  IBUF #(
    .CCIO_EN("TRUE")) 
    reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
