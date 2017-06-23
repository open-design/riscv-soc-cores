# COMMON
set_location_assignment PIN_17 -to CLOCK_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50
set_location_assignment PIN_88 -to RST_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RST_N

# UART
set_location_assignment PIN_126 -to UART_RXD
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_RXD
set_location_assignment PIN_125 -to UART_TXD
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_TXD
