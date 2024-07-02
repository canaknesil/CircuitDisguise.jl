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


module Util

export check_triple, Triple, unite
export find_single, make_histogram, set_if_unset!, print_verbose, print_short, println_short


#
# Triple
#

"Check if x < y < z, considering floating point errors."
function check_triple(x, y, z)
    if x > y && isapprox(x, y)
        x = y
    end
    if z < y && isapprox(y, z)
        z = y
    end
    return x <= y <= z
end

"A subtype of `Number` that represents minimum, typical, and maximum of a value."
struct Triple <: Number
    min
    typical
    max
    function Triple(x, y, z)
        if x > y && isapprox(x, y)
            x = y
        end
        if z < y && isapprox(y, z)
            z = y
        end
        @assert x <= y <= z "$x <= $y <= $z"
        return new(x, y, z)
    end
end

"Make triple from a single number `n`."
Triple(n) = Triple(n, n, n)

"Unite a vector of triples."
unite(v::AbstractVector{Triple}) = Triple(minimum(map(x->x.min, v)),
                                          sum(map(x->x.typical, v)) / length(v),
                                          maximum(map(x->x.max, v)))

Base.:+(x::Triple, y::Triple) = Triple(x.min + y.min, x.typical + y.typical, x.max + y.max)
Base.:-(x::Triple, y::Triple) = Triple(x.min - y.max, x.typical - y.typical, x.max - y.min)
Base.:*(x::Triple, y::Triple) = Triple(x.min * y.min, x.typical * y.typical, x.max * y.max)
Base.promote_rule(::Type{Triple}, ::Type{<:Number}) = Triple

Base.show(io::IO, t::Triple) =
    print(io, "$(t.min):$(t.typical):$(t.max)")


#
# General
#

"Find a single value in `A` that satisfies `f`. If zero or more than one value is found, throw an error."
function find_single(f::Function, A)
    res = filter(f, A)
    if length(res) != 1
        error("Found $(length(res)) items!")
    end
    return res[1]
end


"Return a dictionary with pairs A => B, where A is a value that appear in `v` and B is the number of appearances."
function make_histogram(v::AbstractVector)
    hist = Dict()
    for s in v
        if haskey(hist, s)
            hist[s] += 1
        else
            hist[s] = 1
        end
    end
    return hist
end


"Check if `key` is in `a`. If not, add `key` => `value` to `a`."
function set_if_unset!(a, key, value)
    if !haskey(a, key)
        a[key] = value
    end
    return a[key]
end


#
# Printing
#

"""
    print_verbose(x)
    print_verbose(io::IO, x)

Print `x` to `io` (`stdout` as default) in a similar style return
values are printed in Julia REPL. Types defined in `CircuitDisguise`
are configured to be printed nicely to Julia REPL or through
`print_verbose`.

"""
print_verbose(x) = print_verbose(stdout, x)

function print_verbose(io::IO, x)
    io = IOContext(io, :limit => true)
    show(io, MIME("text/plain"), x)
    println(io)
end


"""
    print_short(x)
    print_short(io::IO, x)

Print `x` to `io` (`stdout` as default) in a short manner, without a
new line at the end.

"""
print_short(x) = print_short(stdout, x)

function print_short(io::IO, x)
    io = IOContext(io, :limit => true)
    print(io, x)
end


"""
    println_short(x)
    println_short(io::IO, x)

Print `x` to `io` (`stdout` as default) in a short manner, with a new
line at the end.

"""
println_short(x) = println_short(stdout, x)

function println_short(io::IO, x)
    print_short(io, x)
    println(io)
end


end # module Util
