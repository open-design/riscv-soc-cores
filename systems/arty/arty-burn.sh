#!/bin/bash

BITSTREAM=$1

source /opt/xilinx/Vivado/2016.3/settings64.sh

TCLFILE=$(tempfile)

cat > $TCLFILE <<EOF
open_hw
connect_hw_server
open_hw_target
current_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7a35t_0] 0]
set_property PROBES.FILE {} [lindex [get_hw_devices xc7a35t_0] 0]
set_property PROGRAM.FILE {$BITSTREAM} [lindex [get_hw_devices xc7a35t_0] 0]
program_hw_devices [lindex [get_hw_devices xc7a35t_0] 0]
refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
set_param xicom.config_chunk_size 0
program_hw_devices -force -svf_file {${BITSTREAM}.svf} [lindex [get_hw_devices xc7a35t_0] 0]
EOF

vivado -mode batch -nojournal -nolog -notrace -source $TCLFILE -tclargs
rm -f $TCLFILE
