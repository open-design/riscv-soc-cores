set_time_format -unit ns -decimal_places 3

# ------------------------------------------
# Create generated clocks based on PLLs
# ------------------------------------------

derive_pll_clocks


# ---------------------------------------------
# Original Clock
# ---------------------------------------------

create_clock -name {CLK100MHZ} -period 10.000 -waveform { 0.000 5.000 } [get_ports {CLK100MHZ}]


# call derive_clock_uncertainty. results will be calculated
# at the next update_timing_netlist call
derive_clock_uncertainty
