# References

```@index
```

## Netlist/Cell Library Conversion

```@docs
convert_cell_library
convert_netlist
convert_netlist_vivado
convert_netlist_other
```

## Main Circuit Disguise Interface

```@docs
read_netlist
disguise_design!
save_design
load_design
check_cycles
check_fanout
check_signal_connections
check_short_circuits
set_delay!
set_primary_port_delay!
set_frequency!
set_primary_input_frequency!
propagate_frequency!
check_power
check_timing!
check_design!
```

## Reports

```@docs
Report
get_name
print_status
```

## Utilities

```@docs
print_verbose
print_short
println_short
find_single
make_histogram
set_if_unset!
Triple
check_triple
unite
```

## Circuit Representation

```@docs
Edge
Vertex
Graph
source
sources
target
targets
edges
vertices
incoming_edges
outgoing_edges
edge_between
add_vertex!
add_edge!
remove_edge!
depth_first_search
feedback_arc_set
topological_sort
Cell
ports
add_port!
Design
DesignNetlist
DisguisedDesign
print_ids
is_primary
is_primary_input
is_primary_output
is_driver
is_bus
is_cycle_driven
is_short_circuit
input_ports
output_ports
```

## Cell Libraries

```@docs
CellLibrary
get_port_direction
get_port_signal_type
get_io_paths
get_ineffective_io_paths
make_cell_library
```

## Netlist Reader

```@docs
read_netlist_json
read_delays_sdf
add_delays_to_design!
make_sdf_delay
find_ports
make_port_pairs
```
