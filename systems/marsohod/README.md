Marsohod3 UART connection
-------------------------

           CN2
   
     1 --  O o  -- 2
           o X
           o o
           o o
           o o  -- 10 (IO[5])  fpga --> host
           o o  -- 12 (IO[7])  fpga <-- host
    13 --  o o  -- 14 (GND)


See also

  * FTDI_BD0 --- 141 (IO8_141/DIFFIO_RX_T52N)
  * FTDI_BD1 --- 140 (IO8_140/DIFFIO_RX_T52P)


Marsohod2RPI
------------

Toggle reset on RPi GPIO8:

  # ( PIN=8; cd /sys/class/gpio; echo $PIN > export; echo low > gpio$PIN/direction; echo $PIN > unexport )
