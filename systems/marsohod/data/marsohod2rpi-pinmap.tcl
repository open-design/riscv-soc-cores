set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

set_location_assignment PIN_88 -to CLK100MHZ

set_location_assignment PIN_80 -to LED[3]
set_location_assignment PIN_83 -to LED[2]
set_location_assignment PIN_84 -to LED[1]
set_location_assignment PIN_85 -to LED[0]

set_location_assignment PIN_91 -to KEY2
set_location_assignment PIN_90 -to KEY1
set_location_assignment PIN_89 -to KEY0

set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_FLASH_NCE_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DCLK_AFTER_CONFIGURATION "USE AS REGULAR IO"

set_location_assignment PIN_12 -to EPCS_DCLK
set_location_assignment PIN_13 -to EPCS_DATA0
set_location_assignment PIN_8 -to EPCS_NCSO
set_location_assignment PIN_6 -to EPCS_ASDO

set_location_assignment PIN_13 -to GPIO8

set_location_assignment PIN_142 -to GPIO14
set_location_assignment PIN_144 -to GPIO15
