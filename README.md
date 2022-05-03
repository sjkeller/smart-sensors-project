# Smart Sensors Project Group 4

## How to execute/simulate testbench

(Warning: for testing purposes I changed the led-state to the 5th-bit of the counter (because simulation is slow))

Compile verilog file
```
iverilog blinking_tb.v -o blinking_tb
```

Execute simulation
```
vvp blinking_tb
```

View generated vcd in gtkwave
```
gtkwave blinking_tb.vcd
```
(dont forget to import the signals in gtkwave on the left (right click on module -> recurse import -> replace))


## Installation GNU/Linux using apt (complicated lol)

```
sudo apt install build-essential clang bison flex gperf libfl2 \
    libfl-dev libreadline-dev gawk tcl-dev libffi-dev \
    graphviz xdot pkg-config python python3 libftdi-dev \
    qt5-default python3-dev libboost-all-dev cmake libeigen3-dev
    
sudo apt install fpga-icestorm yosys
```

[Installing NextPNR](https://github.com/YosysHQ/nextpnr)

## Installation macOS using Homebrew (pretty easy)

```
brew tap ktemkin/oss-fpga

brew install --HEAD icestorm yosys nextpnr-ice40
```

## Installation Windows

Good luck [Micro$oft Winblows Installation](https://wiki.icebreaker-fpga.com/wiki/Getting_started)

## Generate and upload

```
make prog
```

## clean project

```
make clean
```