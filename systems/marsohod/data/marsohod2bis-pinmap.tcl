set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

set_location_assignment PIN_25 -to CLK100MHZ

set_location_assignment PIN_83 -to LED[2]
set_location_assignment PIN_84 -to LED[1]
set_location_assignment PIN_85 -to LED[0]

set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_location_assignment PIN_101 -to IO[0]
set_location_assignment PIN_103 -to IO[1]
set_location_assignment PIN_104 -to IO[2]
set_location_assignment PIN_105 -to IO[3]
set_location_assignment PIN_106 -to IO[4]
set_location_assignment PIN_110 -to IO[5]
set_location_assignment PIN_111 -to IO[6]
set_location_assignment PIN_112 -to IO[7]

set_location_assignment PIN_23 -to KEY0

set_location_assignment PIN_24 -to FTDI_BD0
set_location_assignment PIN_28 -to FTDI_BD1
set_location_assignment PIN_11 -to FTDI_BD2
set_location_assignment PIN_10 -to FTDI_BD3
