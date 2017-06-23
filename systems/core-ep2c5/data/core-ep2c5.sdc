# Main system clock (50 MHz)
create_clock -name "CLOCK_50" -period 20.000ns [get_ports {CLOCK_50}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty
