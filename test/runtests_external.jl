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


include("CircuitDisguiseTest.jl")
using .CircuitDisguiseTest


verbose = false
if length(ARGS) > 0
    if ARGS[1] == "verbose"
        verbose = true
    end
end


external_designs_dir = joinpath(@__DIR__, "../../circuit-disguise-designs/designs")

units = [
    # directory,                                                                                               cell_library,        kw_args...
    #Unit(joinpath(external_designs_dir, "defender_8b10b_encdec/outputs_vivado_xilinx_ultrascale"             ), "xilinx_ultrascale", signal_connection_report=X, timing_report=X),
    #Unit(joinpath(external_designs_dir, "opencores_8b10b_encdec/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", signal_connection_report=X, timing_report=X),

    Unit(joinpath(external_designs_dir, "fpga_em_sensor_tdc/outputs_vivado_xilinx_7"                         ), "xilinx_7"         , timing_report=FAIL, primary_input_frequencies=Dict("clk" => 100e6)),
    #Unit(joinpath(external_designs_dir, "signal_distribution_glitching_load/outputs_vivado_xilinx_ultrascale"), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 100e6)), # 1430s - x
    Unit(joinpath(external_designs_dir, "signal_distribution/outputs_vivado_xilinx_ultrascale"               ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 100e6)), # 51s - x
    #Unit(joinpath(external_designs_dir, "power_hammering_rep/outputs_vivado_xilinx_ultrascale"               ), "xilinx_ultrascale"), # 1381s - 5083s
    Unit(joinpath(external_designs_dir, "power_hammering_rep_with_placement/outputs_vivado_xilinx_ultrascale"), "xilinx_ultrascale"), # 39s - x

    Unit(joinpath(external_designs_dir, "defender_Mali_03_LUTs_RO_I2/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),
    Unit(joinpath(external_designs_dir, "defender_Mali_07_MUX7_RO/outputs_vivado_xilinx_ultrascale"          ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),
    Unit(joinpath(external_designs_dir, "defender_Mali_08_MUX8_RO/outputs_vivado_xilinx_ultrascale"          ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),
    Unit(joinpath(external_designs_dir, "defender_Mali_09_CLA_ADD_RO/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 8s - 17s
    #Unit(joinpath(external_designs_dir, "defender_Mali_10_DSP_RO/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 1207s - x
    Unit(joinpath(external_designs_dir, "defender_Mali_11_Latch_RO/outputs_vivado_xilinx_ultrascale"         ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 14s - 45s
    Unit(joinpath(external_designs_dir, "defender_Mali_12_FF_RO/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", cycle_report=FAIL, signal_connection_report=FAIL, power_report=X, timing_report=X), # 50s - 124s
    Unit(joinpath(external_designs_dir, "defender_Mali_14_LUTs_Dual_Output/outputs_vivado_xilinx_ultrascale" ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X), # 8s - 16s
    Unit(joinpath(external_designs_dir, "defender_Mali_15_Glitch/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", cycle_report=FAIL, signal_connection_report=FAIL, power_report=X, timing_report=X), # 35s - 116s
    Unit(joinpath(external_designs_dir, "defender_Mali_16_Heater/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", cycle_report=FAIL, power_report=X, timing_report=X),

    # Delays specified in xilinx_7_vpr designs are incomplete, leading
    # to invalid timing analysis!
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_ac97_ctrl/outputs_vivado_xilinx_ultrascale"      ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 100e6)),
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_aes_core_xored_output/outputs_f4pga_xilinx_7_vpr"), "xilinx_7_vpr"     , load_capacitance_source="per_wire", timing_report=X), # 38s - 118s
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_aes_core_xored_output/outputs_vivado_xilinx_ultrascale"), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)), # 11s - x
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_aes_core/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)),
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_des_xored_output/outputs_f4pga_xilinx_7_vpr"     ), "xilinx_7_vpr"     , load_capacitance_source="per_wire", timing_report=X), # x - 838s
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_des/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)), # 51s - x
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_ethernet_xored_output/outputs_f4pga_xilinx_7_vpr"), "xilinx_7_vpr"     , load_capacitance_source="per_wire", timing_report=X), # x - 70s
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_ethernet/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 20e6)), # 25s - x
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_fpu/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 2.5e6), cycle_report=FAIL, signal_connection_report=FAIL, power_report=X, timing_report=X),
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_i2c_xored_output/outputs_f4pga_xilinx_7_vpr"     ), "xilinx_7_vpr"     , load_capacitance_source="per_wire", timing_report=X),
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_i2c/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)),
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_mem_ctrl_xored_output/outputs_f4pga_xilinx_7_vpr"), "xilinx_7_vpr"     , load_capacitance_source="per_wire", timing_report=X),
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_mem_ctrl/outputs_vivado_xilinx_ultrascale"       ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 50e6)),
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_pci_xored_output/outputs_f4pga_xilinx_7_vpr"     ), "xilinx_7_vpr"     , load_capacitance_source="per_wire", timing_report=X), # x - 56s
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_pci/outputs_vivado_xilinx_ultrascale"            ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 20e6)), # x - 56s
    #Unit(joinpath(external_designs_dir, "iwls2005_opencores_sasc_xored_output/outputs_f4pga_xilinx_7_vpr"    ), "xilinx_7_vpr"     , load_capacitance_source="per_wire", timing_report=X),
    Unit(joinpath(external_designs_dir, "iwls2005_opencores_sasc/outputs_vivado_xilinx_ultrascale"           ), "xilinx_ultrascale", primary_input_frequencies=Dict("clk" => 100e6)),
]


test_unit(units, verbose=verbose)
