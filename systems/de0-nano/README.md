DE0-Nano
========

DE0-Nano UART connection
------------------------

    .------.
    | 1   2|  2 (GPIO_1[0]) fpga --> host
    | 3   4|  4 (GPIO_1[1]) fpga <-- host
    | .....|
    |    12| 12 (GND)
    |      |
    |      |
    |......|
    |      |
    |39  40|
    '------'
      GPIO-1
       JP2
