# CircuitDisguise.jl

This is the Julia implementation of the Circuit Disguise method
presented in the following research paper manuscript:

Can Aknesil and Elena Dubrova. "Circuit Disguise: Detecting Malicious Circuits in Cloud FPGAs without IP Disclosure".

Circuit Disguise is a method that enables the detection of malicious
circuits in cloud FPGA designs without the clients disclosing their
designs to the cloud in an unprotected form. 

CircuitDisguise.jl mainly includes transformation of a design netlist
into a disguised form and various design checks that can be applied on
a disguised circuit.

## Dependencies

- [Julia programming language](https://julialang.org/)

Julia is an interactive, JIT-compiled programming language that is
commonly used for scientific computing. Circuit Disguise is mainly
implemented in Julia programming language and wrapped in
CircuitDisguise.jl Julia package.

- [Yosys Open Synthesis Suite](https://yosyshq.net/yosys/) (version 0.39 or later)

Yosys is a framework for RTL synthesis. CircuitDisguise.jl uses Yosys
to convert a Verilog netlist to a format suitable to be processed in
Julia. Yosys should be installed and be available in PATH.

## Setup

After the installation of Julia and Yosys, CircuitDisguise.jl
project should be setup. The setup includes automatic installation of
package dependencies, and building the project.

Run the following commands in the repository's top directory:

```
$ julia --project
julia> import Pkg
julia> ENV["PYTHON"] = ""
julia> Pkg.instantiate()
...
julia> Pkg.build()
...
julia> using CircuitDisguise
```

CircuitDisguise.jl internally uses Python for parsing SDF delay files.
Python and Python package dependencies are automatically installed
when CircuitDisguise.jl is setup for the first time as above.

Automatic installation of Python dependencies requires the usage of a
Python instance that is internal to Julia. Julia will automatically
install and use a private Python instance unless told otherwise by
setting the PYTHON environment variable. If Julia was setup before to
use an external Python instance, the `PyCall` Julia package should be
rebuilt for the use of the internal Python instance.

```
$ julia --project
julia> import Pkg
julia> ENV["PYTHON"] = ""
julia> Pkg.build("PyCall")
...
```

## Test

To test CircuitDisguise.jl with designs located in this code
repository, run the following command in the project's top directory:

```
$ julia --project test/runtests.jl
```


## Generate Documentation

To generate documentation, run the following command in the project's top directory:

```
$ julia --project docs/make.jl
```

