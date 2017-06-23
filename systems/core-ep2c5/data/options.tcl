# See Cyclone II FPGA Family Errata, needed for dual-port dual-clock mode M4K
# (http://www.altera.com/support/kdb/solutions/fb27180.html)

set_parameter -name CYCLONEII_SAFE_WRITE  "VERIFIED_SAFE"

set_global_assignment -name GENERATE_CONFIG_SVF_FILE ON
set_global_assignment -name GENERATE_SVF_FILE ON

set_global_assignment -name GENERATE_RBF_FILE ON

set_global_assignment -name USE_CONFIGURATION_DEVICE ON
