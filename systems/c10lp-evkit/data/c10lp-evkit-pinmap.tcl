set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS_INPUT_TRI_STATED"
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED"
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"

set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"

set_location_assignment PIN_M15 -to CLK50MHZ
set_location_assignment PIN_D9 -to USER_PB[3]
set_location_assignment PIN_C11 -to USER_PB[2]
set_location_assignment PIN_F14 -to USER_PB[1]
set_location_assignment PIN_E15 -to USER_PB[0]
set_location_assignment PIN_J13 -to USER_LED[3]
set_location_assignment PIN_J14 -to USER_LED[2]
set_location_assignment PIN_K15 -to USER_LED[1]
set_location_assignment PIN_L14 -to USER_LED[0]

set_location_assignment PIN_B1 -to ARDUINO_IO0
set_location_assignment PIN_C2 -to ARDUINO_IO1
