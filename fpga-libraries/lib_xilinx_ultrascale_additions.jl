# MIT License

# Copyright (c) 2024 Can Aknesil

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# This file contains additional information of FPGA design elements
# (cells) gathered from vendor documentations.

# The variables defined in this file is used in CellLibraries.jl.


#
# Cell port signal types
#

# Possible signal types are clock, asynchronous, constant, primary, data, and any.

cell_port_signal_types_xilinx_ultrascale = Dict(
    # AND2B1L
    # BITSLICE_CONTROL
    # BSCANE2
    # BUFG
    # BUFG_GT
    # BUFG_GT_SYNC
    # BUFG_PS
    "BUFGCE" => Dict(
        "CE" => "data",
        "I" => "clock",
        "O" => "clock",
    ),
    # BUFGCE_1
    # BUFGCE_DIV
    # BUFCTRL
    # BUFGMUX
    # BUFGMUX_1
    # BUFGMUX_CTRL
    "CARRY8" => Dict(
        "CI" => "data",
        "CI_TOP" => "data",
        "DI" => "data",
        "S" => "data",
        "CO" => "data",
        "O" => "data",
    ),
    # CFGLUT5
    # CMAC
    # CMACE4
    # DCIRESET
    # DNA_PORTE2
    # DSP48E2
    "DSP_A_B_DATA" => Dict(
        "A" => "data",
        "ACIN" => "data",
        "B" => "data",
        "BCIN" => "data",
        "CEA1" => "data",
        "CEA2" => "data",
        "CEB1" => "data",
        "CEB2" => "data",
        "CLK" => "clock",
        "RSTA" => "data",
        "RSTB" => "data",
        "ACOUT" => "data",
        "A_ALU" => "data",
        "A1_DATA" => "data",
        "A2_DATA" => "data",
        "BCOUT" => "data",
        "B_ALU" => "data",
        "B1_DATA" => "data",
        "B2_DATA" => "data",
    ),
    "DSP_ALU" => Dict(
        "ALUMODE" => "data",
        "AMULT26" => "data",
        "A_ALU" => "data",
        "BMULT17" => "data",
        "B_ALU" => "data",
        "CARRYCASCIN" => "data",
        "CARRYIN" => "data",
        "CARRYINSEL" => "data",
        "CCOUT" => "data",
        "CEALUMODE" => "data",
        "CECARRYIN" => "data",
        "CECTRL" => "data",
        "CEM" => "data",
        "CLK" => "clock",
        "C_DATA" => "data",
        "MULTSIGNIN" => "data",
        "OPMODE" => "data",
        "PCIN" => "data",
        "P_FDBK" => "data",
        "P_FDBK_47" => "data",
        "RSTALLCARRYIN" => "data",
        "RSTALUMODE" => "data",
        "RSTCTRL" => "data",
        "U_DATA" => "data",
        "V_DATA" => "data",
        "ALUMODE10" => "data",
        "ALU_OUT" => "data",
        "COUT" => "data",
        "MULTSIGN_ALU" => "data",
        "XOR_MX" => "data",
    ),
    "DSP_C_DATA" => Dict(
        "C" => "data",
        "CEC" => "data",
        "CLK" => "clock",
        "RSTC" => "data",
        "C_DATA" => "data",
    ),
    "DSP_M_DATA" => Dict(
        "CEM" => "data",
        "CLK" => "clock",
        "RSTM" => "data",
        "U" => "data",
        "U_DATA" => "data",
        "V" => "data",
        "V_DATA" => "data",
    ),
    "DSP_MULTIPLIER" => Dict(
        "AD_DATA" => "data",
        "A2A1" => "data",
        "B2B1" => "data",
        "AMULT26" => "data",
        "BMULT17" => "data",
        "U" => "data",
        "V" => "data",
    ),
    "DSP_OUTPUT" => Dict(
        "ALUMODE10" => "data",
        "ALU_OUT" => "data",
        "CEP" => "data",
        "CLK" => "clock",
        "COUT" => "data",
        "C_DATA" => "data",
        "MULTSIGN_ALU" => "data",
        "RSTP" => "data",
        "XOR_MX" => "data",
        "CARRYCASCOUT" => "data",
        "CARRYOUT" => "data",
        "CCOUT_FB" => "data",
        "MULTSIGNOUT" => "data",
        "OVERFLOW" => "data",
        "P" => "data",
        "PATTERN_B_DETECT" => "data",
        "PATTERN_DETECT" => "data",
        "PCOUT" => "data",
        "P_FDBK" => "data",
        "P_FDBK_47" => "data",
        "UNDERFLOW" => "data",
        "XOROUT" => "data",
    ),
    "DSP_PREADD" => Dict(
        "ADDSUB" => "data",
        "D_DATA" => "data",
        "INMODE2" => "data",
        "PREADD_AB" => "data",
        "AD" => "data",
    ),
    "DSP_PREADD_DATA" => Dict(
        "AD" => "data",
        "A1_DATA" => "data",
        "A2_DATA" => "data",
        "B1_DATA" => "data",
        "B2_DATA" => "data",
        "CEAD" => "data",
        "CED" => "data",
        "CEINMODE" => "data",
        "CLK" => "clock",
        "DIN" => "data",
        "INMODE" => "data",
        "RSTD" => "data",
        "RSTINMODE" => "data",
        "ADDSUB" => "data",
        "AD_DATA" => "data",
        "A2A1" => "data",
        "B2B1" => "data",
        "D_DATA" => "data",
        "INMODE_2" => "data",
        "PREADD_AB" => "data",
    ),
    # EFUSE_USR
    "FDCE" => Dict(
        "D" => "data",
        "CE" => "data",
        "C" => "clock",
        "CLR" => "asynchronous",
        "Q" => "data",
    ),
    "FDPE" => Dict(
        "D" => "data",
        "CE" => "data",
        "C" => "clock",
        "PRE" => "asynchronous",
        "Q" => "data",
    ),
    "FDRE" => Dict(
        "D" => "data",
        "CE" => "data",
        "C" => "clock",
        "R" => "asynchronous",
        "Q" => "data",
    ),
    "FDSE" => Dict(
        "D" => "data",
        "CE" => "data",
        "C" => "clock",
        "S" => "data",
        "Q" => "data",
    ),
    # FIFO18E2
    # FIFO36E2
    # FRAME_ECCE3
    # FRAME_ECCE4
    "GND" => Dict(
        "G" => "constant",
    ),
    # GTHE3_CHANNEL
    # GTHE3_COMMON
    # GTHE4_CHANNEL
    # GTHE4_COMMON
    # GTYE3_CHANNEL
    # GTYE3_COMMON
    # GTYE4_CHANNEL
    # GTYE4_COMMON
    # HARD_SYNC
    # HPIO_VREF
    # IBUF is subsitited with INBUF and IBUFCTRL
    # "IBUF" => Dict(
    #     "I" => "primary",
    #     "O" => "primary",
    # ),
    # IBUF_ANALOG
    # IBUF_IBUFDISABLE
    # IBUF_INTERMDISABLE
    # IBUFCTRL is not in library documentation
    "IBUFCTRL" => Dict(
        "I" => "primary",
        "IBUFDISABLE" => "data",
        "INTERMDISABLE" => "data",
        "T" => "data",
        "O" => "primary",
    ),
    # IBUFDS
    # IBUFDS_DIFF_OUT
    # IBUFDS_DIFF_OUT_IBUFDISABLE
    # IBUFDS_DIFF_OUT_INTERMDISABLE
    # IBUFDS_DPHY
    # IBUFDS_GTE3
    # IBUFDS_GTE4
    # IBUFDS_IBUFDISABLE
    # IBUFDS_INTERMDISABLE
    # IBUFDSE3
    # IBUFE3
    # ICAPE3
    # IDDRE1
    # IDELAYCTRL
    # IDELAYE3
    # ILKN
    # ILKNE4
    # INBUF is not in library documentation
    "INBUF" => Dict(
        "OSC_EN" => "data",
        "PAD" => "primary",
        "VREF" => "data",
        "OSC" => "data",
        "O" => "primary",
    ),
    # IOBUF
    # IOBUF_DCIEN
    # IOBUF_INTERMDISABLE
    # IOBUFDS
    # IOBUFDS_DCIEN
    # IOBUFDS_DIFF_OUT
    # IOBUFDS_DIFF_OUT_DCIEN
    # IOBUFDS_DIFF_OUT_INTERMDISABLE
    # IOBUFDS_INTERMDISABLE
    # IOBUFDSE3
    # IOBUFE3
    # ISERDESE3
    # KEEPER
    "LDCE" => Dict(
        "D" => "data",
        "GE" => "data",
        "G" => "clock",
        "CLR" => "asynchronous",
        "Q" => "data",
    ),
    # LDPE
    "LUT1" => Dict(
        "I0" => "data",
        "O" => "data",
    ),
    "LUT2" => Dict(
        "I0" => "data",
        "I1" => "data",
        "O" => "data",
    ),
    "LUT3" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "O" => "data",
    ),
    "LUT4" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "I3" => "data",
        "O" => "data",
    ),
    "LUT5" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "I3" => "data",
        "I4" => "data",
        "O" => "data",
    ),
    "LUT6" => Dict(
        "I0" => "data",
        "I1" => "data",
        "I2" => "data",
        "I3" => "data",
        "I4" => "data",
        "I5" => "data",
        "O" => "data",
    ),
    # LUT6_2 (shouldn't exist, subtituted with LUT5 and LUT6)
    # MASTER_JTAG
    # MMCME3_ADV
    # MMCME3_BASE
    # MMCME4_ADV
    # MMCME4_BASE
    "MUXF7" => Dict(
        "I0" => "data",
        "I1" => "data",
        "S" => "data",
        "O" => "data",
    ),
    "MUXF8" => Dict(
        "I0" => "data",
        "I1" => "data",
        "S" => "data",
        "O" => "data",
    ),
    "MUXF9" => Dict(
        "I0" => "data",
        "I1" => "data",
        "S" => "data",
        "O" => "data",
    ),
    "OBUF" => Dict(
        "I" => "primary",
        "O" => "primary",
    ),
    # OBUFDS
    # OBUFDS_DPHY
    # OBUFDS_GTE3
    # OBUFDS_GTE3_ADV
    # OBUFDS_GTE4
    # OBUFDS_GTE4_ADV
    "OBUFT" => Dict(
        "T" => "data",
        "I" => "primary",
        "O" => "primary",
    ),
    # OBUFTDS
    # ODDRE1
    # ODELAYE3
    # OR2L
    # OSERDESE3
    # PCIE40E4
    # PCIE_3_1
    # PLLE3_ADV
    # PLLE3_BASE
    # PLLE4_ADV
    # PLLE4_BASE
    # PULLDOWN
    # PULLUP
    # RAM128X1D
    # RAM128X1S
    # RAM256X1D
    # RAM256X1S
    # RAM32M
    "RAM32M16" => Dict(
        "DIA" => "data",
        "DIB" => "data",
        "DIC" => "data",
        "DID" => "data",
        "DIE" => "data",
        "DIF" => "data",
        "DIG" => "data",
        "DIH" => "data",
        "ADDRA" => "data",
        "ADDRB" => "data",
        "ADDRC" => "data",
        "ADDRD" => "data",
        "ADDRE" => "data",
        "ADDRF" => "data",
        "ADDRG" => "data",
        "ADDRH" => "data",
        "WE" => "data",
        "WCLK" => "clock",
        "DOA" => "data",
        "DOB" => "data",
        "DOC" => "data",
        "DOD" => "data",
        "DOE" => "data",
        "DOF" => "data",
        "DOG" => "data",
        "DOH" => "data",
    ),
    # RAM32X16DR8
    "RAM32X1D" => Dict(
        "WE" => "data",
        "D" => "data",
        "WCLK" => "clock",
        "A0" => "data",
        "A1" => "data",
        "A2" => "data",
        "A3" => "data",
        "A4" => "data",
        "DPRA0" => "data",
        "DPRA1" => "data",
        "DPRA2" => "data",
        "DPRA3" => "data",
        "DPRA4" => "data",
        "SPO" => "data",
        "DPO" => "data",
    ),
    # RAM32X1S
    # RAM512X1S
    # RAM64M
    "RAM64M8" => Dict(
        "DIA" => "data",
        "DIB" => "data",
        "DIC" => "data",
        "DID" => "data",
        "DIE" => "data",
        "DIF" => "data",
        "DIG" => "data",
        "DIH" => "data",
        "ADDRA" => "data",
        "ADDRB" => "data",
        "ADDRC" => "data",
        "ADDRD" => "data",
        "ADDRE" => "data",
        "ADDRF" => "data",
        "ADDRG" => "data",
        "ADDRH" => "data",
        "WE" => "data",
        "WCLK" => "clock",
        "DOA" => "data",
        "DOB" => "data",
        "DOC" => "data",
        "DOD" => "data",
        "DOE" => "data",
        "DOF" => "data",
        "DOG" => "data",
        "DOH" => "data",
    ),
    "RAM64X1D" => Dict(
        "WE" => "data",
        "D" => "data",
        "WCLK" => "clock",
        "A0" => "data",
        "A1" => "data",
        "A2" => "data",
        "A3" => "data",
        "A4" => "data",
        "A5" => "data",
        "DPRA0" => "data",
        "DPRA1" => "data",
        "DPRA2" => "data",
        "DPRA3" => "data",
        "DPRA4" => "data",
        "DPRA5" => "data",
        "SPO" => "data",
        "DPO" => "data",
    ),
    # RAM64X1S
    # RAM64X8SW
    "RAMB18E2" => Dict(
        "CASDIMUXA" => "data",
        "CASDIMUXB" => "data",
        "CASDINA" => "data",
        "CASDINB" => "data",
        "CASDINPA" => "data",
        "CASDINPB" => "data",
        "CASDOMUXA" => "data",
        "CASDOMUXB" => "data",
        "CASDOMUXEN_A" => "data",
        "CASDOMUXEN_B" => "data",
        "CASDOUTA" => "data",
        "CASDOUTB" => "data",
        "CASDOUTPA" => "data",
        "CASDOUTPB" => "data",
        "CASOREGIMUXA" => "data",
        "CASOREGIMUXB" => "data",
        "CASOREGIMUXEN_A" => "data",
        "CASOREGIMUXEN_B" => "data",
        "ADDRARDADDR" => "data",
        "ADDRENA" => "data",
        "CLKARDCLK" => "clock",
        "ENARDEN" => "data",
        "REGCEAREGCE" => "data",
        "RSTRAMARSTRAM" => "data",
        "RSTREGARSTREG" => "data",
        "WEA" => "data",
        "DINADIN" => "data",
        "DINPADINP" => "data",
        "DOUTADOUT" => "data",
        "DOUTPADOUTP" => "data",
        "ADDRBWRADDR" => "data",
        "ADDRENB" => "data",
        "CLKBWRCLK" => "data",
        "ENBWREN" => "data",
        "REGCEB" => "data",
        "RSTRAMB" => "data",
        "RSTREGB" => "data",
        "SLEEP" => "asynchronous", # If SLEEP_ASYNC=FALSE, synchronous to RDCLK, OTHERWISE, asynchronous.
        "WEBWE" => "data",
        "DINBDIN" => "data",
        "DINPBDINP" => "data",
        "DOUTBDOUT" => "data",
        "DOUTPBDOUTP" => "data",
    ),
    # RAMB36E2
    "RAMD32" => Dict(
        "CLK" => "clock",
        "I" => "data",
        "O" => "data",
        "RADR0" => "data",
        "RADR1" => "data",
        "RADR2" => "data",
        "RADR3" => "data",
        "RADR4" => "data",
        "WADR0" => "data",
        "WADR1" => "data",
        "WADR2" => "data",
        "WADR3" => "data",
        "WADR4" => "data",
        "WE" => "data",
    ),
    "RAMD64E" => Dict(
        "CLK" => "clock",
        "I" => "data",
        "O" => "data",
        "RADR0" => "data",
        "RADR1" => "data",
        "RADR2" => "data",
        "RADR3" => "data",
        "RADR4" => "data",
        "RADR5" => "data",
        "WADR0" => "data",
        "WADR1" => "data",
        "WADR2" => "data",
        "WADR3" => "data",
        "WADR4" => "data",
        "WADR5" => "data",
        "WADR6" => "data",
        "WADR7" => "data",
        "WE" => "data",
    ),
    "RAMS32" => Dict(
        "CLK" => "clock",
        "I" => "data",
        "O" => "data",
        "ADR0" => "data",
        "ADR1" => "data",
        "ADR2" => "data",
        "ADR3" => "data",
        "ADR4" => "data",
        "WE" => "data",
    ),
    # RIU_OR
    # RX_BITSLICE
    # RXTX_BITSLICE
    "SRL16E" => Dict(
        "D" => "data",
        "CE" => "data",
        "CLK" => "clock",
        "A0" => "data",
        "A1" => "data",
        "A2" => "data",
        "A3" => "data",
        "Q" => "data",
    ),
    "SRLC32E" => Dict(
        "A" => "data",
        "CE" => "data",
        "CLK" => "clock",
        "D" => "data",
        "Q" => "data",
        "Q31" => "data",
    ),
    # STARTUPE3
    # SYSMONE1
    # SYSMONE4
    # TX_BITSLICE
    # TX_BITSLICE_TRI
    # URAM288
    # URAM288_BASE
    # USR_ACCESSE2
    "VCC" => Dict(
        "P" => "constant",
    ),
    # TODO: Complete the list cell_port_signal_types_xilinx_ultrascale
)


#
# Cell port directions
#

# Possible directions are data and output.

cell_port_directions_xilinx_ultrascale = Dict(
    # AND2B1L
    # BITSLICE_CONTROL
    # BSCANE2
    # BUFG
    # BUFG_GT
    # BUFG_GT_SYNC
    # BUFG_PS
    "BUFGCE" => Dict(
        "CE" => "input",
        "I" => "input",
        "O" => "output",
    ),
    # BUFGCE_1
    # BUFGCE_DIV
    # BUFCTRL
    # BUFGMUX
    # BUFGMUX_1
    # BUFGMUX_CTRL
    "CARRY8" => Dict(
        "CI" => "input",
        "CI_TOP" => "input",
        "DI" => "input",
        "S" => "input",
        "CO" => "output",
        "O" => "output",
    ),
    # CFGLUT5
    # CMAC
    # CMACE4
    # DCIRESET
    # DNA_PORTE2
    # DSP48E2
    "DSP_A_B_DATA" => Dict(
        "A" => "input",
        "ACIN" => "input",
        "B" => "input",
        "BCIN" => "input",
        "CEA1" => "input",
        "CEA2" => "input",
        "CEB1" => "input",
        "CEB2" => "input",
        "CLK" => "input",
        "RSTA" => "input",
        "RSTB" => "input",
        "ACOUT" => "output",
        "A_ALU" => "output",
        "A1_DATA" => "output",
        "A2_DATA" => "output",
        "BCOUT" => "output",
        "B_ALU" => "output",
        "B1_DATA" => "output",
        "B2_DATA" => "output",
    ),
    "DSP_ALU" => Dict(
        "ALUMODE" => "input",
        "AMULT26" => "input",
        "A_ALU" => "input",
        "BMULT17" => "input",
        "B_ALU" => "input",
        "CARRYCASCIN" => "input",
        "CARRYIN" => "input",
        "CARRYINSEL" => "input",
        "CCOUT" => "input",
        "CEALUMODE" => "input",
        "CECARRYIN" => "input",
        "CECTRL" => "input",
        "CEM" => "input",
        "CLK" => "clock",
        "C_DATA" => "input",
        "MULTSIGNIN" => "input",
        "OPMODE" => "input",
        "PCIN" => "input",
        "P_FDBK" => "input",
        "P_FDBK_47" => "input",
        "RSTALLCARRYIN" => "input",
        "RSTALUMODE" => "input",
        "RSTCTRL" => "input",
        "U_DATA" => "input",
        "V_DATA" => "input",
        "ALUMODE10" => "output",
        "ALU_OUT" => "output",
        "COUT" => "output",
        "MULTSIGN_ALU" => "output",
        "XOR_MX" => "output",
    ),
    "DSP_C_DATA" => Dict(
        "C" => "input",
        "CEC" => "input",
        "CLK" => "input",
        "RSTC" => "input",
        "C_DATA" => "output",
    ),
    "DSP_M_DATA" => Dict(
        "CEM" => "input",
        "CLK" => "input",
        "RSTM" => "input",
        "U" => "input",
        "U_DATA" => "output",
        "V" => "input",
        "V_DATA" => "output",
    ),
    "DSP_MULTIPLIER" => Dict(
        "AD_DATA" => "input",
        "A2A1" => "input",
        "B2B1" => "input",
        "AMULT26" => "output",
        "BMULT17" => "output",
        "U" => "output",
        "V" => "output",
    ),
    "DSP_OUTPUT" => Dict(
        "ALUMODE10" => "input",
        "ALU_OUT" => "input",
        "CEP" => "input",
        "CLK" => "input",
        "COUT" => "input",
        "C_DATA" => "input",
        "MULTSIGN_ALU" => "input",
        "RSTP" => "input",
        "XOR_MX" => "input",
        "CARRYCASCOUT" => "output",
        "CARRYOUT" => "output",
        "CCOUT_FB" => "output",
        "MULTSIGNOUT" => "output",
        "OVERFLOW" => "output",
        "P" => "output",
        "PATTERN_B_DETECT" => "output",
        "PATTERN_DETECT" => "output",
        "PCOUT" => "output",
        "P_FDBK" => "output",
        "P_FDBK_47" => "output",
        "UNDERFLOW" => "output",
        "XOROUT" => "output",
    ),
    "DSP_PREADD" => Dict(
        "ADDSUB" => "input",
        "D_DATA" => "input",
        "INMODE2" => "input",
        "PREADD_AB" => "input",
        "AD" => "output",
    ),
    "DSP_PREADD_DATA" => Dict(
        "AD" => "input",
        "A1_DATA" => "input",
        "A2_DATA" => "input",
        "B1_DATA" => "input",
        "B2_DATA" => "input",
        "CEAD" => "input",
        "CED" => "input",
        "CEINMODE" => "input",
        "CLK" => "clock",
        "DIN" => "input",
        "INMODE" => "input",
        "RSTD" => "input",
        "RSTINMODE" => "input",
        "ADDSUB" => "output",
        "AD_DATA" => "output",
        "A2A1" => "output",
        "B2B1" => "output",
        "D_DATA" => "output",
        "INMODE_2" => "output",
        "PREADD_AB" => "output",
    ),
    # EFUSE_USR
    "FDCE" => Dict(
        "D" => "input",
        "CE" => "input",
        "C" => "input",
        "CLR" => "input",
        "Q" => "output",
    ),
    "FDPE" => Dict(
        "D" => "input",
        "CE" => "input",
        "C" => "input",
        "PRE" => "input",
        "Q" => "output",
    ),
    "FDRE" => Dict(
        "D" => "input",
        "CE" => "input",
        "C" => "input",
        "R" => "input",
        "Q" => "output",
    ),
    "FDSE" => Dict(
        "D" => "input",
        "CE" => "input",
        "C" => "input",
        "S" => "input",
        "Q" => "output",
    ),
    # FIFO18E2
    # FIFO36E2
    # FRAME_ECCE3
    # FRAME_ECCE4
    "GND" => Dict(
        "G" => "output",
    ),
    # GTHE3_CHANNEL
    # GTHE3_COMMON
    # GTHE4_CHANNEL
    # GTHE4_COMMON
    # GTYE3_CHANNEL
    # GTYE3_COMMON
    # GTYE4_CHANNEL
    # GTYE4_COMMON
    # HARD_SYNC
    # HPIO_VREF
    # IBUF is subtituted by INBUF and IBUFCTRL
    # "IBUF" => Dict(
    #     "I" => "input",
    #     "O" => "output",
    # ),
    # IBUF_ANALOG
    # IBUF_IBUFDISABLE
    # IBUF_INTERMDISABLE
    # IBUFDS
    # IBUFDS_DIFF_OUT
    # IBUFDS_DIFF_OUT_IBUFDISABLE
    # IBUFDS_DIFF_OUT_INTERMDISABLE
    # IBUFDS_DPHY
    # IBUFDS_GTE3
    # IBUFDS_GTE4
    # IBUFDS_IBUFDISABLE
    # IBUFDS_INTERMDISABLE
    # IBUFDSE3
    # IBUFE3
    # ICAPE3
    # IDDRE1
    # IDELAYCTRL
    # IDELAYE3
    # ILKN
    # ILKNE4
    # INBUF is not in library documentation
    "INBUF" => Dict(
        "OSC_EN" => "input",
        "PAD" => "input",
        "VREF" => "input",
        "OSC" => "input",
        "O" => "output",
    ),
    # IOBUF
    # IOBUF_DCIEN
    # IOBUF_INTERMDISABLE
    # IBUFCTRL is not in library documentation
    "IBUFCTRL" => Dict(
        "I" => "input",
        "IBUFDISABLE" => "input",
        "INTERMDISABLE" => "input",
        "T" => "input",
        "O" => "output",
    ),
    # IOBUFDS
    # IOBUFDS_DCIEN
    # IOBUFDS_DIFF_OUT
    # IOBUFDS_DIFF_OUT_DCIEN
    # IOBUFDS_DIFF_OUT_INTERMDISABLE
    # IOBUFDS_INTERMDISABLE
    # IOBUFDSE3
    # IOBUFE3
    # ISERDESE3
    # KEEPER
    "LDCE" => Dict(
        "D" => "input",
        "GE" => "input",
        "G" => "input",
        "CLR" => "input",
        "Q" => "output",
    ),
    # LDPE
    "LUT1" => Dict(
        "I0" => "input",
        "O" => "output",
    ),
    "LUT2" => Dict(
        "I0" => "input",
        "I1" => "input",
        "O" => "output",
    ),
    "LUT3" => Dict(
        "I0" => "input",
        "I1" => "input",
        "I2" => "input",
        "O" => "output",
    ),
    "LUT4" => Dict(
        "I0" => "input",
        "I1" => "input",
        "I2" => "input",
        "I3" => "input",
        "O" => "output",
    ),
    "LUT5" => Dict(
        "I0" => "input",
        "I1" => "input",
        "I2" => "input",
        "I3" => "input",
        "I4" => "input",
        "O" => "output",
    ),
    "LUT6" => Dict(
        "I0" => "input",
        "I1" => "input",
        "I2" => "input",
        "I3" => "input",
        "I4" => "input",
        "I5" => "input",
        "O" => "output",
    ),
    # LUT6_2 (shouldn't exist, subtituted with LUT5 and LUT6)
    # MASTER_JTAG
    # MMCME3_ADV
    # MMCME3_BASE
    # MMCME4_ADV
    # MMCME4_BASE
    "MUXF7" => Dict(
        "I0" => "input",
        "I1" => "input",
        "S" => "input",
        "O" => "output",
    ),
    "MUXF8" => Dict(
        "I0" => "input",
        "I1" => "input",
        "S" => "input",
        "O" => "output",
    ),
    "MUXF9" => Dict(
        "I0" => "input",
        "I1" => "input",
        "S" => "input",
        "O" => "output",
    ),
    "OBUF" => Dict(
        "I" => "input",
        "O" => "output",
    ),
    # OBUFDS
    # OBUFDS_DPHY
    # OBUFDS_GTE3
    # OBUFDS_GTE3_ADV
    # OBUFDS_GTE4
    # OBUFDS_GTE4_ADV
    "OBUFT" => Dict(
        "T" => "input",
        "I" => "input",
        "O" => "output",
    ),
    # OBUFTDS
    # ODDRE1
    # ODELAYE3
    # OR2L
    # OSERDESE3
    # PCIE40E4
    # PCIE_3_1
    # PLLE3_ADV
    # PLLE3_BASE
    # PLLE4_ADV
    # PLLE4_BASE
    # PULLDOWN
    # PULLUP
    # RAM128X1D
    # RAM128X1S
    # RAM256X1D
    # RAM256X1S
    # RAM32M
    "RAM32M16" => Dict(
        "DIA" => "input",
        "DIB" => "input",
        "DIC" => "input",
        "DID" => "input",
        "DIE" => "input",
        "DIF" => "input",
        "DIG" => "input",
        "DIH" => "input",
        "ADDRA" => "input",
        "ADDRB" => "input",
        "ADDRC" => "input",
        "ADDRD" => "input",
        "ADDRE" => "input",
        "ADDRF" => "input",
        "ADDRG" => "input",
        "ADDRH" => "input",
        "WE" => "input",
        "WCLK" => "input",
        "DOA" => "output",
        "DOB" => "output",
        "DOC" => "output",
        "DOD" => "output",
        "DOE" => "output",
        "DOF" => "output",
        "DOG" => "output",
        "DOH" => "output",
    ),
    # RAM32X16DR8
    "RAM32X1D" => Dict(
        "WE" => "input",
        "D" => "input",
        "WCLK" => "input",
        "A0" => "input",
        "A1" => "input",
        "A2" => "input",
        "A3" => "input",
        "A4" => "input",
        "DPRA0" => "input",
        "DPRA1" => "input",
        "DPRA2" => "input",
        "DPRA3" => "input",
        "DPRA4" => "input",
        "SPO" => "output",
        "DPO" => "output",
    ),
    # RAM32X1S
    # RAM512X1S
    # RAM64M
    "RAM64M8" => Dict(
        "DIA" => "input",
        "DIB" => "input",
        "DIC" => "input",
        "DID" => "input",
        "DIE" => "input",
        "DIF" => "input",
        "DIG" => "input",
        "DIH" => "input",
        "ADDRA" => "input",
        "ADDRB" => "input",
        "ADDRC" => "input",
        "ADDRD" => "input",
        "ADDRE" => "input",
        "ADDRF" => "input",
        "ADDRG" => "input",
        "ADDRH" => "input",
        "WE" => "input",
        "WCLK" => "input",
        "DOA" => "output",
        "DOB" => "output",
        "DOC" => "output",
        "DOD" => "output",
        "DOE" => "output",
        "DOF" => "output",
        "DOG" => "output",
        "DOH" => "output",
    ),
    "RAM64X1D" => Dict(
        "WE" => "input",
        "D" => "input",
        "WCLK" => "input",
        "A0" => "input",
        "A1" => "input",
        "A2" => "input",
        "A3" => "input",
        "A4" => "input",
        "A5" => "input",
        "DPRA0" => "input",
        "DPRA1" => "input",
        "DPRA2" => "input",
        "DPRA3" => "input",
        "DPRA4" => "input",
        "DPRA5" => "input",
        "SPO" => "output",
        "DPO" => "output",
    ),
    # RAM64X1S
    # RAM64X8SW
    "RAMB18E2" => Dict(
        "CASDIMUXA" => "input",
        "CASDIMUXB" => "input",
        "CASDINA" => "input",
        "CASDINB" => "input",
        "CASDINPA" => "input",
        "CASDINPB" => "input",
        "CASDOMUXA" => "input",
        "CASDOMUXB" => "input",
        "CASDOMUXEN_A" => "input",
        "CASDOMUXEN_B" => "input",
        "CASDOUTA" => "output",
        "CASDOUTB" => "output",
        "CASDOUTPA" => "output",
        "CASDOUTPB" => "output",
        "CASOREGIMUXA" => "input",
        "CASOREGIMUXB" => "input",
        "CASOREGIMUXEN_A" => "input",
        "CASOREGIMUXEN_B" => "input",
        "ADDRARDADDR" => "input",
        "ADDRENA" => "input",
        "CLKARDCLK" => "input",
        "ENARDEN" => "input",
        "REGCEAREGCE" => "input",
        "RSTRAMARSTRAM" => "input",
        "RSTREGARSTREG" => "input",
        "WEA" => "input",
        "DINADIN" => "input",
        "DINPADINP" => "input",
        "DOUTADOUT" => "output",
        "DOUTPADOUTP" => "output",
        "ADDRBWRADDR" => "input",
        "ADDRENB" => "input",
        "CLKBWRCLK" => "input",
        "ENBWREN" => "input",
        "REGCEB" => "input",
        "RSTRAMB" => "input",
        "RSTREGB" => "input",
        "SLEEP" => "input",
        "WEBWE" => "input",
        "DINBDIN" => "input",
        "DINPBDINP" => "input",
        "DOUTBDOUT" => "output",
        "DOUTPBDOUTP" => "output",
    ),
    # RAMB36E2
    "RAMD32" => Dict(
        "CLK" => "input",
        "I" => "input",
        "O" => "output",
        "RADR0" => "input",
        "RADR1" => "input",
        "RADR2" => "input",
        "RADR3" => "input",
        "RADR4" => "input",
        "WADR0" => "input",
        "WADR1" => "input",
        "WADR2" => "input",
        "WADR3" => "input",
        "WADR4" => "input",
        "WE" => "input",
    ),
    "RAMD64E" => Dict(
        "CLK" => "input",
        "I" => "input",
        "O" => "output",
        "RADR0" => "input",
        "RADR1" => "input",
        "RADR2" => "input",
        "RADR3" => "input",
        "RADR4" => "input",
        "RADR5" => "input",
        "WADR0" => "input",
        "WADR1" => "input",
        "WADR2" => "input",
        "WADR3" => "input",
        "WADR4" => "input",
        "WADR5" => "input",
        "WADR6" => "input",
        "WADR7" => "input",
        "WE" => "input",
    ),
    "RAMS32" => Dict(
        "CLK" => "input",
        "I" => "input",
        "O" => "output",
        "ADR0" => "input",
        "ADR1" => "input",
        "ADR2" => "input",
        "ADR3" => "input",
        "ADR4" => "input",
        "WE" => "input",
    ),
    # RIU_OR
    # RX_BITSLICE
    # RXTX_BITSLICE
    "SRL16E" => Dict(
        "D" => "input",
        "CE" => "input",
        "CLK" => "input",
        "A0" => "input",
        "A1" => "input",
        "A2" => "input",
        "A3" => "input",
        "Q" => "output",
    ),
    "SRLC32E" => Dict(
        "A" => "input",
        "CE" => "input",
        "CLK" => "input",
        "D" => "input",
        "Q" => "output",
        "Q31" => "output",
    ),
    # STARTUPE3
    # SYSMONE1
    # SYSMONE4
    # TX_BITSLICE
    # TX_BITSLICE_TRI
    # URAM288
    # URAM288_BASE
    # USR_ACCESSE2
    "VCC" => Dict(
        "P" => "output",
    ),
    # TODO: Complete the list cell_port_signal_types_xilinx_ultrascale
)


#
# Cell IO paths
#

# Additional IO paths that is not defined in SDF file.

# (src_port_name, bus_index, dst_port_name, bus_index)
# bus_index is nothing if port is not a bus, or the specification applies all bits.

cell_io_paths_xilinx_ultrascale = Dict(
    # When compiling ac97_ctrl, IO path of OBUF is not defined in SDF
    # file.
    "OBUF" => [
        ("I", nothing, "O", nothing),
    ],
)


#
# Cell ineffective IO paths functions
#

cell_ineffective_io_paths_funcs_xilinx_ultrascale = Dict(
    "LUT1" => (params -> cell_ineffective_io_paths_func_lut_k(1, params)),
    "LUT2" => (params -> cell_ineffective_io_paths_func_lut_k(2, params)),
    "LUT3" => (params -> cell_ineffective_io_paths_func_lut_k(3, params)),
    "LUT4" => (params -> cell_ineffective_io_paths_func_lut_k(4, params)),
    "LUT5" => (params -> cell_ineffective_io_paths_func_lut_k(5, params)),
    "LUT6" => (params -> cell_ineffective_io_paths_func_lut_k(6, params)),
)
