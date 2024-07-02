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


module SDFParser

# This module is a wrapper for sdf_parser.py.

# One option to setup the python environment:
#
# Use the python version internal to julia.
# ENV["PYTHON"]=""
# Pkg.build("PyCall")
#
# pyimport_conda is used below to automatically install neccessary
# python packages.
#
# Otherwire, the required python packages can also be installed via
# Conda julia package.
# e.g. Conda.add("ply")

import PyCall as pc
sdf = pc.PyNULL()
import JSON


export parse_sdf_file


function parse_sdf_file(fname::AbstractString)
    if !isfile(fname)
        error("'$fname' is not a file!")
    end
    return JSON.parse(sdf.parse_sdf_file(fname))
end


function __init__()
    # Make sure necessary Python packages are installed.
    pc.pyimport_conda("ply", "ply")
    pc.pyimport_conda("json", "json")

    # By default, PyCall doesn't include the current directory in the
    # Python search path. The next line enables loading a Python
    # module from the specified directory. Use "" for current
    # directory.
    pushfirst!(pc.pyimport("sys")."path", @__DIR__)
    
    copy!(sdf, pc.pyimport("sdf_parser"))
end


end # module SDFParser
