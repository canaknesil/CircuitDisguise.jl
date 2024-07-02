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


using Profile

# Code taken from test_design.jl

include("CircuitDisguiseTest.jl")
using .CircuitDisguiseTest
using CircuitDisguise


@assert length(ARGS) == 2
cell_library = ARGS[1]
netlist_dir = ARGS[2]

println("Cell library: $cell_library")
println("Testing design at $netlist_dir")


println("Dummy execution before profiling...")
reports = test_design(netlist_dir, cell_library; verbose=false)

println("Execution for profiling...")
Profile.init(n=1000000000) # default n = 10000000 is not sufficient for aes_core external test
reports = @profile test_design(netlist_dir, cell_library; verbose=false)

open(joinpath(@__DIR__, "profiler.log"), "w") do io
    Profile.print(IOContext(io, :displaysize => (24, 250)), format=:flat, noisefloor=2.0)
end
println("Done.")
