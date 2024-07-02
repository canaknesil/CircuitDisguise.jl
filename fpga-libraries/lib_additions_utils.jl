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


function cell_ineffective_io_paths_func_lut_k(k::Integer, params)
    @assert k >= 1
    
    # init(1^k-1 downto 0)
    init = params["INIT"]
    @assert length(init) == 2 ^ k
    init = map(c -> parse(Int, c), collect(init))

    io_paths = []

    for i = 0:(k-1)
        init_r = reshape(init, 2^i, :)
        init_1 = reshape(init_r[:, begin:2:end], :)
        init_2 = reshape(init_r[:, begin+1:2:end], :)
        #println(init_1)
        #println(init_2)

        if init_1 == init_2
            push!(io_paths, "I$i" => "O")
        end
    end

    return io_paths
end

