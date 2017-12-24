set_time_format -unit ns -decimal_places 3

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Main system clock (50 MHz)
create_clock -name {CLK50MHZ} -period 20.000 [get_ports {CLK50MHZ}]

# call derive_clock_uncertainty. results will be calculated
# at the next update_timing_netlist call
derive_clock_uncertainty
