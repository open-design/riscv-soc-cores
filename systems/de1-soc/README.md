DE1-SoC
=======

DE1-SoC UART connection
-----------------------

    .------.
    | 1   2|  2 (GPIO_0[1]) fpga --> host
    | 3   4|  4 (GPIO_0[3]) fpga <-- host
    | .....|
    \    12| 12 (GND)
     |     |
    /      |
    |      |
    |      |
    |39  40|
    '------'
      GPIO0


DE1-SoC programming
-------------------

/opt/altera/16.1/quartus/bin/quartus_pgm de1-soc.cdf

de1-soc.cdf contents:
```
/* Quartus Prime Version 16.1.2 Build 203 01/18/2017 SJ Lite Edition */
JedecChain;
        FileRevision(JESD32A);
        DefaultMfr(6E);

        P ActionCode(Ign)
                Device PartName(SOCVHPS) MfrSpec(OpMask(0));
        P ActionCode(Cfg)
                Device PartName(5CSEMA5F31) Path("/tmp/") File("de1-soc-picorv32-wb-soc_0.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
        ChainType(JTAG);
AlteraEnd;
```
