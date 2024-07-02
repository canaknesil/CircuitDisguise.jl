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


module CircuitRepresentation

export Edge, Vertex, Graph, source, target, edges, incoming_edges, outgoing_edges, targets, sources, edge_between, vertices, add_vertex!, add_edge!, remove_edge!
export depth_first_search, feedback_arc_set, topological_sort
export Cell, ports, add_port!
export Design, DesignNetlist, DisguisedDesign
export print_ids, is_primary, is_primary_input, is_primary_output, is_driver, is_bus, is_cycle_driven, is_short_circuit, input_ports, output_ports


# Very short summary: Design netlist is read into a graph where
# vertices represent primary ports and cells ports, edges represent
# wires. An additional array stores cells. Every cell points to their
# ports.


#
# Graph data structure
#

"`Graph` edge type."
struct Edge{T}
    id::Symbol  # for debugging purposes, not for addressing
    src::T # ::Vertex
    dst::T # ::Vertex
    attributes::Dict
    Edge{T}(src, dst, attributes) where T = new(gensym(), src, dst, attributes)
end

"`Graph` vertex type."
struct Vertex
    id::Symbol
    edges::Vector{Edge}
    attributes::Dict
    Vertex(edges, attributes) = new(gensym(), edges, attributes)
end

"Make vertex."
Vertex() = Vertex([], Dict())

"Make edge."
Edge(src, dst) = Edge{Vertex}(src, dst, Dict())

"Directed graph type."
struct Graph
    vertices::Vector{Vertex}
end

"Make graph."
Graph() = Graph([])


#
# Basic graph functions (independent of attributes)
#

"Return source vertex of an edge."
source(e::Edge) = e.src

"Return target vertex of an edge."
target(e::Edge) = e.dst

"Return edges connected to a vertex."
edges(v::Vertex) = v.edges

"Return incoming edges of a vertex."
incoming_edges(v::Vertex) = filter(e -> e.dst == v, edges(v))

"Return outgoing edges of a vertex."
outgoing_edges(v::Vertex) = filter(e -> e.src == v, edges(v))

"Return targets of a vertex."
targets(v::Vertex) = map(e -> e.dst, outgoing_edges(v))

"Return sources of a vertex."
sources(v::Vertex) = map(e -> e.src, incoming_edges(v))

"Return edge between two vertices."
function edge_between(src::Vertex, dst::Vertex)
    e = filter(e->target(e) == dst, outgoing_edges(src))
    if isempty(e)
        return nothing
    elseif length(e) == 1
        return e[1]
    else
        error("More than one edge between a pair of vertices!")
    end
end

"Return vertices of a graph."
vertices(g::Graph) = g.vertices

"Return edges of a graph."
function edges(g::Graph)
    set = Set{Edge}()
    for v in vertices(g)
        for e in edges(v)
            push!(set, e)
        end
    end
    return collect(set)
end

"Add vertex to graph."
add_vertex!(g::Graph, v::Vertex) = push!(g.vertices, v)

"Add edge to graph."
function add_edge!(g::Graph, e::Edge)
    if !isnothing(edge_between(source(e), target(e)))
        error("More than one edges between one pair of vertices is not allowed!")
    end
    if source(e) == target(e)
        error("Self-loop is not allowed!")
    end

    # The code below supports self-loops anyway.
    push!(e.src.edges, e)
    if e.src != e.dst
        push!(e.dst.edges, e)
    end
end

"Remove edge between two vertices in a graph."
function remove_edge!(src::Vertex, dst::Vertex)
    out_edges = filter(e -> e.dst == dst, outgoing_edges(src))
    in_edges = filter(e -> e.src == src, incoming_edges(dst))
    @assert length(out_edges) == length(in_edges)
    @assert length(out_edges) <= 1
    if length(out_edges) == 1
        out_edge = out_edges[1]
        in_edge = in_edges[1]
        filter!(!=(out_edge), src.edges)
        filter!(!=(in_edge), dst.edges)
    end
end

function Base.show(io::IO, g::Graph)
    v_list = vertices(g)
    e_list = edges(g)
    print(io, "Graph with $(length(v_list)) vertices $(length(e_list)) edges")
end

function Base.show(io::IO, ::MIME"text/plain", g::Graph)
    println(io, "Graph with vertices...")
    show(io, MIME("text/plain"), vertices(g))
    println(io)
    println(io, "edges...")
    show(io, MIME("text/plain"), edges(g))
    println(io)
end

function Base.show(io::IO, v::Vertex)
    print(io, "Vertex $(v.id): ")
    print_attributes(io, v.attributes)
end

function Base.show(io::IO, ::MIME"text/plain", v::Vertex)
    print(io, "Vertex $(v.id): ")
    print_attributes(io, v.attributes)
    println(io)
    println(io, "with edges...")
    show(io, MIME("text/plain"), v.edges)
    println(io)
end

function Base.show(io::IO, e::Edge)
    print(io, "Edge $(e.id) from $(e.src.id) to $(e.dst.id): ")
    print_attributes(io, e.attributes)
end


#
# Basic graph algorithms (temporarily using attributes)
#

# dsf attribute values:
# WHITE: not discovered
# GRAY: discovered
# BLACK: finished

# Algorithms were inspired from
# Cormen et al. Introduction to Algorithms. 2022

"Depth first search on a graph starting from a single root vertex."
depth_first_search(g::Graph, root_vertex::Vertex; kwargs...) =
    depth_first_search(g, [root_vertex]; kwargs...)


"Depth first search on a graph starting from multiple root vertices."
function depth_first_search(g::Graph, root_vertices::AbstractVector{Vertex}=vertices(g); kwargs...)
    for v in vertices(g)
        v["dfs"] = "WHITE"
    end

    for v in root_vertices
        if v["dfs"] == "WHITE"
            depth_first_search(v; kwargs...)
        end
    end

    # Not deleting dfs key for faster execution.
    # for v in vertices(g)
    #     delete!(v, "dfs")
    # end
end


function depth_first_search(v::Vertex;
                            backwards=false,
                            cb_at_revisit_gray::Function=e->nothing,
                            cb_at_discovery::Function=v->nothing,
                            cb_at_finish::Function=v->nothing)
    v["dfs"] = "GRAY"
    cb_at_discovery(v)

    if backwards
        adjacent_edges = incoming_edges(v)
    else
        adjacent_edges = outgoing_edges(v)
    end
    
    for e in adjacent_edges
        if backwards
            v2 = source(e)
        else
            v2 = target(e)
        end
        color = v2["dfs"]
        if color == "WHITE"
            depth_first_search(v2; backwards, cb_at_revisit_gray, cb_at_discovery, cb_at_finish)
        elseif color == "GRAY"
            cb_at_revisit_gray(e)
        end
    end
    v["dfs"] = "BLACK"
    cb_at_finish(v)
end


"Return feedback arc set from a graph."
function feedback_arc_set(g::Graph)
    arcs = []
    depth_first_search(g; cb_at_revisit_gray = e->push!(arcs, e))
    return arcs
end


"Return vertices of a graph in topological order."
function topological_sort(g::Graph)
    list = []
    depth_first_search(g; cb_at_finish = v->pushfirst!(list, v))
    return list
end



#
# Cell structure: an addition to graph data structure to specify cell
# boudaries and attributes.
#

"`DesignNetlist` cell type."
struct Cell
    id::Symbol
    ports::Vector{Vertex}
    attributes::Dict
    Cell(ports, attributes) = new(gensym(), ports, attributes)
end

"Make cell."
Cell() = Cell([], Dict())

"Return ports of a cell."
ports(c::Cell) = c.ports

"Add port to a cell."
add_port!(c::Cell, port::Vertex) = push!(c.ports, port)


function Base.show(io::IO, c::Cell)
    print(io, "Cell $(c.id): ")
    print_attributes(io, c.attributes)
    print(io, " with ports ")
    print_ids(io, ports(c))
end

function Base.show(io::IO, ::MIME"text/plain", c::Cell)
    print(io, "Cell $(c.id): ")
    print_attributes(io, c.attributes)
    println(io)
    println(io, "with ports...")
    show(io, MIME("text/plain"), ports(c))
    println(io)
end


#
# Design record to represent an FPGA design before or after disguise.
#

"Supertype of `DesignNetlist` and `DisguisedDesign`."
abstract type Design end

"Design netlist type to represent a design before disguise."
struct DesignNetlist <: Design
    graph::Graph
    primary_ports::Vector{Vertex}
    cells::Vector{Cell}
    attributes::Dict
end

"Make DesignNetlist."
DesignNetlist(graph, primary_ports, cells) = DesignNetlist(graph, primary_ports, cells, Dict())

"Disguised design type to represent a design after disguise."
struct DisguisedDesign <: Design
    graph::Graph
    primary_ports::Vector{Vertex}
    attributes::Dict
end


function Base.show(io::IO, design::DesignNetlist)
    print(io, "DesignNetlist")
end

function Base.show(io::IO, ::MIME"text/plain", design::DesignNetlist)
    println(io, "DesignNetlist")
    #print_attributes(io, design.attributes)
    println(io, "with cells...")
    show(io, MIME("text/plain"), design.cells)
    println(io)
    println(io, "with graph...")
    show(io, MIME("text/plain"), design.graph)
end

function Base.show(io::IO, design::DisguisedDesign)
    print(io, "DisguisedDesign")
end

function Base.show(io::IO, ::MIME"text/plain", design::DisguisedDesign)
    println(io, "DisguisedDesign")
    #print_attributes(io, design.attributes)
    println(io, "with graph...")
    show(io, MIME("text/plain"), design.graph)
end


#
# Attribute access
#

Base.getindex(e::Edge, key) = e.attributes[key]
Base.getindex(e::Vertex, key) = e.attributes[key]
Base.getindex(e::Cell, key) = e.attributes[key]
Base.getindex(e::Design, key) = e.attributes[key]

Base.setindex!(e::Edge, val, key) = e.attributes[key] = val
Base.setindex!(e::Vertex, val, key) = e.attributes[key] = val
Base.setindex!(e::Cell, val, key) = e.attributes[key] = val
Base.setindex!(e::Design, val, key) = e.attributes[key] = val

Base.haskey(e::Edge, key) = haskey(e.attributes, key)
Base.haskey(e::Vertex, key) = haskey(e.attributes, key)
Base.haskey(e::Cell, key) = haskey(e.attributes, key)
Base.haskey(e::Design, key) = haskey(e.attributes, key)

Base.delete!(e::Edge, key) = delete!(e.attributes, key)
Base.delete!(e::Vertex, key) = delete!(e.attributes, key)
Base.delete!(e::Cell, key) = delete!(e.attributes, key)
Base.delete!(e::Design, key) = delete!(e.attributes, key)


#
# Utility functions (dependent to attributes)
#

function print_attributes(io::IO, a::AbstractDict)
    allkeys = collect(keys(a))
    if isempty(allkeys)
        print(io, "()")
    else
        k = popfirst!(allkeys)
        print(io, "($k => ")
        print_attributes(io, a[k])
        for k in allkeys
            print(io, ", $k => ")
            print_attributes(io, a[k])
        end
        print(io, ")")
    end
end

print_attributes(io::IO, a) = print(io, a)


"Print a list of IDs."
print_ids(list) = print_ids(stdout, list)

function print_ids(io::IO, list::AbstractVector{T}) where T <: Union{Vertex, Edge, Cell}
    if isempty(list)
        print(io, "[]")
    else
        print(io, "[")
        print(io, string(list[1].id))
        for p in list[2:end]
            print(io, ", ")
            print(io, string(p.id))
        end
        print(io, "]")
    end
end


"Return if port is a primary I/O."
is_primary(port::Vertex) =
    haskey(port, "flag_primary") && port["flag_primary"]

"Return if port is a primary input."
is_primary_input(port::Vertex) =
    is_primary(port) && port["direction"] == "input"

"Return if port is a primary output."
is_primary_output(port::Vertex) =
    is_primary(port) && port["direction"] == "output"

"Return if port is a primary input, or a cell output."
is_driver(port::Vertex) = 
    (is_primary(port) && port["direction"] == "input") ||
    (!is_primary(port) && port["direction"] == "output")

"Return if port is a bus."
is_bus(port::Vertex) = haskey(port, "bus_index")

"Return if edge is cycle driven."
is_cycle_driven(x::Edge) =
    haskey(x, "cycle_driven") && x["cycle_driven"]

"Return if vertex is flagged as a short circuit."
is_short_circuit(x::Vertex) =
    haskey(x, "flag_short_circuit") && x["flag_short_circuit"]

"Return input ports of a cell."
input_ports(c::Cell) = filter(p -> p["direction"] == "input", ports(c))

"Return output ports of a cell."
output_ports(c::Cell) = filter(p -> p["direction"] == "output", ports(c))


end # module CircuitRepresentation
