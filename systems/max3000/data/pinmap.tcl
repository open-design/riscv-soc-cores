set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"

set_global_assignment -name MAX7000_DEVICE_IO_STANDARD "3.3-V LVTTL"

set_location_assignment PIN_2 -to UART0_TXD
set_location_assignment PIN_3 -to UART0_RXD

set_location_assignment PIN_10 -to LED1
set_location_assignment PIN_8 -to LED2

set_location_assignment PIN_42 -to GPIO0
set_location_assignment PIN_43 -to GPIO1

set_location_assignment PIN_31 -to UART1_TXD
set_location_assignment PIN_28 -to UART1_RXD

set_location_assignment PIN_27 -to UART2_TXD
set_location_assignment PIN_25 -to UART2_RXD

set_location_assignment PIN_15 -to I2C_SEL
