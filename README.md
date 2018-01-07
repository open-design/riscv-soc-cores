riscv-soc-cores
===============

This repo contains core description files for FuseSoC
to create a simple RISC-V-based SoC for FPGA.
Based on https://github.com/openrisc/orpsoc-cores.

It is intended to implement as fully-featured
system as possible, depending on the targeted hardware.

Currently supported FPGA boards:

| Board | FPGA | on-chip RAM | external RAM |
| :---- | :--: | :---------: | :------:     |
| | [Cyclone II](https://www.altera.com/products/fpga/cyclone-series/cyclone-ii/support.html)
| [Waveshare CoreEP2C5](http://www.waveshare.com/wiki/CoreEP2C5)               | EP2C5T144C8  | 8 KiB  |             |
| [Altera DE1 Board](https://www.terasic.com.tw/cgi-bin/page/archive.pl?No=83) | EP2C20F484C7 | 16 KiB | 8 MiB SDRAM |
| | [Cyclone III](https://www.altera.com/products/fpga/cyclone-series/cyclone-iii/overview.html)
| [Marsohod2](https://marsohod.org/howtostart/marsohod2) | EP3C10E144C8 | 16 KiB | 8 MiB SDRAM |
| | [Cyclone IV](https://www.altera.com/products/fpga/cyclone-series/cyclone-iv/overview.html)
| [Waveshare CoreEP4CE6](http://www.waveshare.com/wiki/CoreEP4CE6) | EP4CE6E22C8 | 16 KiB |   |
| [Marsohod2bis](https://marsohod.org/11-blog/289-marsohod2bis)    | EP4CE6E22C8 | 16 KiB | 8 MiB SDRAM  |
| | [MAX 10](https://www.altera.com/products/fpga/max-series/max-10/overview.html)
| [Marsohod3](https://marsohod.org/howtostart/plata-marsokhod3) | 10M50SAE144C8GES | 64 KiB | 8 MiB SDRAM |
| | [Cyclone 10 LP](https://www.altera.com/products/fpga/cyclone-series/cyclone-10/cyclone-10-lp/overview.html)
| [Intel Cyclone 10 LP FPGA Evaluation Kit](https://www.altera.com/products/boards_and_kits/dev-kits/altera/cyclone-10-lp-evaluation-kit.html) | 10CL025YU256I7G | 16 KiB |   |
| | [Artix-7](https://www.xilinx.com/products/silicon-devices/fpga/artix-7.html)
| [Digilent Arty A7-35T](http://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/) | XC7A35T-L1CSG324I | 16 KiB |   |


# Preparing

First install fusesoc:

```
$ sudo apt-get install python-pip
$ git clone https://github.com/olofk/fusesoc
$ cd fusesoc
$ sudo pip install -e .
```


# Simulation

Install Icarus Verilog and GtkWave software:

```
$ sudo apt-get install iverilog gtkwave
```

elf-loader needs libelf-dev so install it:

```
$ sudo apt-get install libelf-dev
```

Simulation:

```
$ fusesoc --cores-root cores/ sim picorv32-wb-soc
$ gtkwave build/picorv32-wb-soc_0/sim-icarus/picorv32-wb-soc.vcd
```


# Build

Marsohod2 needs Quartus <= 13.1:

```
$ export PATH=$PATH:/opt/altera/13.1/quartus/bin
$ fusesoc --cores-root cores/ build marsohod2-picorv32-wb-soc
```

Marsohod3 needs Quartus >= 15.0:

```
$ export PATH=$PATH:/opt/altera/16.0/quartus/bin
$ fusesoc --cores-root cores/ build marsohod3-picorv32-wb-soc
```


# Programmming FPGA

Marsohod2:

```
$ sudo openocd -f board/marsohod2.cfg -c init -c "svf -tap ep3c10.tap build/marsohod2-picorv32-wb-soc_0/bld-quartus/marsohod2-picorv32-wb-soc_0.svf" -c shutdown

```

Marsohod3:

```
$ sudo openocd -f board/marsohod3.cfg -c init -c "svf -tap 10m50.tap build/marsohod3-picorv32-wb-soc_0/bld-quartus/marsohod3-picorv32-wb-soc_0.svf" -c shutdown
```
