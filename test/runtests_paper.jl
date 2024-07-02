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


# This file contains tests presented in the Circuit Disguise
# paper. They are a subset of tests in runtests.jl and
# runtests_external.jl.


include("CircuitDisguiseTest.jl")
using .CircuitDisguiseTest


verbose = false
if length(ARGS) > 0
    if ARGS[1] == "verbose"
        verbose = true
    end
end


external_designs_dir = joinpath(@__DIR__, "../../circuit-disguise-paper-benchmarks/designs")

units = [
    # directory,                                                                                               cell_library,        kw_args...

    # 1 - LUT cycle
    Unit(joinpath(external_designs_dir, "defender_Mali_03_LUTs_RO_I2/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),

    # 2 - Dual cycle via 2-output LUT
    Unit(joinpath(external_designs_dir, "defender_Mali_14_LUTs_Dual_Output/outputs_vivado_xilinx_ultrascale" ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 8s - 16s

    # 3 - LUT cycle-based heater
    Unit(joinpath(external_designs_dir, "defender_Mali_16_Heater/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),

    # 4 - MUX7 cycle
    Unit(joinpath(external_designs_dir, "defender_Mali_07_MUX7_RO/outputs_vivado_xilinx_ultrascale"          ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),

    # 5 - MUX8 cycle
    Unit(joinpath(external_designs_dir, "defender_Mali_08_MUX8_RO/outputs_vivado_xilinx_ultrascale"          ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),

    # 6 - CARRY8 cycle
    Unit(joinpath(external_designs_dir, "defender_Mali_09_CLA_ADD_RO/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 8s - 17s

    # 7 - DSP48E2 cycle
    #Unit(joinpath(external_designs_dir, "defender_Mali_10_DSP_RO/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 1207s - x

    # 8 - Transparent latch cycle
    Unit(joinpath(external_designs_dir, "defender_Mali_11_Latch_RO/outputs_vivado_xilinx_ultrascale"         ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 14s - 45s

    # 9 - Self-triggering FF (through asynchronous reset)
    Unit(joinpath(external_designs_dir, "defender_Mali_12_FF_RO/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", cycle_report=FAIL, signal_connection_report=FAIL, power_report=X, timing_report=X), # 50s - 124s

    # 10 - Self-triggering FF (clock glitching)
    Unit(joinpath(external_designs_dir, "defender_Mali_15_Glitch/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", cycle_report=FAIL, signal_connection_report=FAIL, power_report=X, timing_report=X), # 35s - 116s

    # 11 - Glitch amplification (reproduced according to "Power hammering..." paper
    Unit(joinpath(external_designs_dir, "power_hammering_rep_with_placement/outputs_vivado_xilinx_ultrascale"), "xilinx_ultrascale"), # 39s - x

    # 12 - Time-to-digital converter
    Unit(joinpath(external_designs_dir, "fpga_em_sensor_tdc/outputs_vivado_xilinx_7"                         ), "xilinx_7"         , timing_report=FAIL, primary_input_frequencies=Dict("clk" => 100e6)),

    # 13 - Signal distribution network
    #Unit(joinpath(external_designs_dir, "signal_distribution_glitching_load/outputs_vivado_xilinx_ultrascale"), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 100e6)), # 1430s - x

    # 14 - Short circuit (post-synthesis)
    Unit(joinpath(external_designs_dir, "short_circuit/outputs_vivado_xilinx_ultrascale"                     ), "xilinx_ultrascale", short_circuit_report=FAIL, power_report=X),

    # 15 - ac97_ctrl
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_ac97_ctrl/outputs_vivado_xilinx_ultrascale"      ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 100e6)),

    # 16 - aes_core
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_aes_core/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)),

    # 17 - des
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_des/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)), # 51s - x

    # 18 - ethernet
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_ethernet/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 20e6)), # 25s - x

    # 19 - fpu
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_fpu/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 2.5e6), cycle_report=FAIL, signal_connection_report=FAIL, power_report=X, timing_report=X),

    # 20 - i2c
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_i2c/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)),

    # 21 - mem_ctrl
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_mem_ctrl/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)),

    # 22 - pci
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_pci/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 20e6)), # x - 56s

    # 23 - sasc
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_sasc/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 100e6)),

    # 24 - Clock divider
    Unit(joinpath(external_designs_dir, "internal_clock_generation/outputs_vivado_xilinx_ultrascale"         ), "xilinx_ultrascale", signal_connection_report=FAIL, primary_input_frequencies=Dict("clk" => 100e6)),

    # 25 - Packed LUT6_2 cycle
    Unit(joinpath(external_designs_dir, "lut6x2_benign_loop/outputs_vivado_xilinx_ultrascale"                ), "xilinx_ultrascale"),
]


test_unit(units, verbose=verbose)
