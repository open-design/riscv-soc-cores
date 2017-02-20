#!/bin/sh

set -x
set -e

report_board()
{
	PROJ=$1
	NUM_COLUMNS=$2

# Quartus 13.3:
#   marsohod2 -> NUM_COLUMNS=19
#   de0-nano  -> NUM_COLUMNS=19
#   de1-soc   -> NUM_COLUMNS=22
# Quartus 16.0:
#   de0-nano  -> NUM_COLUMNS=19
#   de1-soc   -> NUM_COLUMNS=22
#   marsohod3 -> NUM_COLUMNS=21

	echo $PROJ
	echo

	grep -B 1 -A $NUM_COLUMNS "; Flow Summary" $PROJ/*.flow.rpt
	grep -B 1 -A 5 "; Slow .* 85C Model Fmax Summary" $PROJ/*.sta.rpt | sed "s/^.*.sta.rpt.//"

	echo
}

SAVE_PATH=$PATH

QV=16.0
export PATH=$SAVE_PATH:/opt/altera/$QV/quartus/bin
QUARTUS_NAME=q$QV
BUILD=build.$QUARTUS_NAME

rm -rf build
fusesoc --cores-root cores/ build marsohod2bis-picorv32-wb-soc
fusesoc --cores-root cores/ build marsohod2bis-vscale-wb-soc
fusesoc --cores-root cores/ build marsohod3-picorv32-wb-soc
fusesoc --cores-root cores/ build marsohod3-vscale-wb-soc
mv build $BUILD

REPORT=REPORT.$QUARTUS_NAME
echo > $REPORT
report_board $BUILD/marsohod2bis-picorv32-wb-soc_0/bld-quartus 19 | tee -a $REPORT
report_board $BUILD/marsohod2bis-vscale-wb-soc_0/bld-quartus 19 | tee -a $REPORT
report_board $BUILD/marsohod3-picorv32-wb-soc_0/bld-quartus 21 | tee -a $REPORT
report_board $BUILD/marsohod3-vscale-wb-soc_0/bld-quartus 21 | tee -a $REPORT

QV=13.1
export PATH=$SAVE_PATH:/opt/altera/$QV/quartus/bin
QUARTUS_NAME=q$QV
BUILD=build.$QUARTUS_NAME

rm -rf build
fusesoc --cores-root cores/ build marsohod2-picorv32-wb-soc
fusesoc --cores-root cores/ build marsohod2-vscale-wb-soc
fusesoc --cores-root cores/ build marsohod2bis-picorv32-wb-soc
fusesoc --cores-root cores/ build marsohod2bis-vscale-wb-soc
mv build $BUILD

REPORT=REPORT.$QUARTUS_NAME
echo > $REPORT
report_board $BUILD/marsohod2-picorv32-wb-soc_0/bld-quartus 19 | tee -a $REPORT
report_board $BUILD/marsohod2-vscale-wb-soc_0/bld-quartus 19 | tee -a $REPORT
report_board $BUILD/marsohod2bis-picorv32-wb-soc_0/bld-quartus 19 | tee -a $REPORT
report_board $BUILD/marsohod2bis-vscale-wb-soc_0/bld-quartus 19 | tee -a $REPORT
