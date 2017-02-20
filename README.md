riscv-soc-cores
===============

Core description files for FuseSoC.

Based on https://github.com/openrisc/orpsoc-cores.


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
$ fusesoc --cores-root cores/ sim marsohod2-picorv32-wb-soc
$ gtkwave build/marsohod2-picorv32-wb-soc_0/sim-icarus/picorv32-wb-soc.vcd
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
