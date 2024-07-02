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


# runtests.jl performs tests on the small designs located in the
# project repository. They are aimed to be sufficient for unit
# testing.

# runtests_external.jl performs tests on designs located in a
# secondary design repository that doesn't have a storage restriction.


include("CircuitDisguiseTest.jl")
using .CircuitDisguiseTest


verbose = false
if length(ARGS) > 0
    if ARGS[1] == "verbose"
        verbose = true
    end
end


units = [
    # directory,                                                                                       cell_libra,          kw_args...
    Unit(joinpath(simple_designs_dir, "and_gate/outputs_vivado_xilinx_7"),                             "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "counter/outputs_vivado_xilinx_7"),                              "xilinx_7"         , primary_input_frequencies=Dict("clk" => 100e6)),
    Unit(joinpath(simple_designs_dir, "counter/outputs_vivado_xilinx_7"),                              "xilinx_7"         , load_capacitance_source="per_wire", primary_input_frequencies=Dict("clk" => 100e6)),
    Unit(joinpath(simple_designs_dir, "dsp_slice_without_registers/outputs_vivado_xilinx_7"),          "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "dsp_slice_with_registers/outputs_vivado_xilinx_7"),             "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "lut6x2_lut5s/outputs_vivado_xilinx_7"),                         "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "lut6x2_packed_logic/outputs_vivado_xilinx_7"),                  "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "lut6x2_benign_loop/outputs_vivado_xilinx_7"),                   "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "lut6x2_benign_loop/outputs_vivado_xilinx_ultrascale"),          "xilinx_ultrascale"),
    Unit(joinpath(simple_designs_dir, "seq_logic/outputs_vivado_xilinx_7"),                            "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "seq_logic_without_timing_constraints/outputs_vivado_xilinx_7"), "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "small_signal_distribution_glitch/outputs_vivado_xilinx_7"),     "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "small_signal_distribution_glitch/outputs_vivado_xilinx_7"),     "xilinx_7"         , max_dynamic_power_threshold=8, power_report=FAIL),
    Unit(joinpath(simple_designs_dir, "small_signal_distribution_glitch/outputs_vivado_xilinx_7"),     "xilinx_7"         , total_dynamic_power_threshold=16, power_report=FAIL),
    Unit(joinpath(simple_designs_dir, "small_signal_distribution_glitch/outputs_vivado_xilinx_7"),     "xilinx_7"         , average_fanout_threshold=1, fanout_report=FAIL),
    Unit(joinpath(simple_designs_dir, "small_signal_distribution_glitch/outputs_vivado_xilinx_7"),     "xilinx_7"         , max_fanout_threshold=2, fanout_report=FAIL),
    Unit(joinpath(simple_designs_dir, "transparent_latch/outputs_vivado_xilinx_7"),                    "xilinx_7"         ),
    Unit(joinpath(simple_designs_dir, "lut_loop/outputs_vivado_xilinx_7"),                             "xilinx_7"         , cycle_report=FAIL, power_report=X, timing_report=X),
    Unit(joinpath(simple_designs_dir, "mux_loop/outputs_vivado_xilinx_7"),                             "xilinx_7"         , cycle_report=FAIL, power_report=X, timing_report=X),
    Unit(joinpath(simple_designs_dir, "self_triggering_ff_clk_glitching/outputs_vivado_xilinx_7"),     "xilinx_7"         , cycle_report=FAIL, signal_connection_report=FAIL, power_report=X, timing_report=X),
    Unit(joinpath(simple_designs_dir, "transparent_latch_loop/outputs_vivado_xilinx_7"),               "xilinx_7"         , cycle_report=FAIL, power_report=X, timing_report=X),
    Unit(joinpath(simple_designs_dir, "internal_clock_generation/outputs_vivado_xilinx_7"),            "xilinx_7"         , signal_connection_report=FAIL, primary_input_frequencies=Dict("clk" => 100e6)),
    Unit(joinpath(simple_designs_dir, "internal_clock_generation/outputs_vivado_xilinx_ultrascale"),   "xilinx_ultrascale", signal_connection_report=FAIL, primary_input_frequencies=Dict("clk" => 100e6)),
    Unit(joinpath(simple_designs_dir, "short_circuit/outputs_vivado_xilinx_7"),                        "xilinx_7"         , short_circuit_report=FAIL, power_report=X),
    Unit(joinpath(simple_designs_dir, "short_circuit/outputs_vivado_xilinx_ultrascale"),               "xilinx_ultrascale", short_circuit_report=FAIL, power_report=X),
]


test_unit(units, verbose=verbose)
test_examples(verbose=verbose)
