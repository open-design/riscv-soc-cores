set_global_assignment -name FLOW_ENABLE_IO_ASSIGNMENT_ANALYSIS ON

# Workaround for synthesis tool crash, solution ID rd11072013_978
set_global_assignment -name AUTO_RAM_BLOCK_BALANCING OFF

set_global_assignment -name GENERATE_CONFIG_SVF_FILE ON
set_global_assignment -name GENERATE_SVF_FILE ON
