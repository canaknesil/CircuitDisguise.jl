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


module Reports

using ..Util

export Report, get_name, print_status


"Generic report type."
struct Report
    name
    passed::Bool
    content
end

"""
    get_name(r::Report)

Return name of report `r`.

"""
get_name(r::Report) = r.name


"""
    print_status(r::Report)
    print_status(io::IO, r::Report)

Print status of report `r` to `io` (`stdout` as default) followed by
its name.

"""
print_status(r::Report) = print_status(stdout, r)

function print_status(io::IO, r::Report)
    name = get_name(r)
    print(io, "$name: ")
    if r.passed
        print(io, "Passed")
    else
        print(io, "Failed")
    end
    println(io)
end


function Base.show(io::IO, ::MIME"text/plain", r::Report)
    print_status(io, r)
    @assert isa(r.content, NamedTuple)
    for k in keys(r.content)
        print(io, "$k: ")
        print_verbose(io, getindex(r.content, k))
        #show(io, MIME("text/plain"), getindex(r.content, k))
        #println(io)
    end
end


end # module Reports
