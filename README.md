# Smart Sensors Project Group 4

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