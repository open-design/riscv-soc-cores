#!/bin/bash

set -x
set -e

quartus_report()
{
	PROJ=$1

	echo $PROJ
	echo

	awk 'seen {print} /^; Flow Summary/ {seen = 1; print "Flow Summary"} /^$/ {seen = 0}' $PROJ/*.flow.rpt
	grep -B 1 -A 5 "; .*Model Fmax Summary" $PROJ/*.sta.rpt | sed "s/^.*.sta.rpt.//"

	echo
}

build_quartus()
{
	QUARTUS_NAME=$1
	QUARTUS_PATH=$2
	SYSTEMS=$3

	SAVE_PATH=$PATH
	export PATH=$SAVE_PATH:$QUARTUS_PATH
	BUILD=build.$QUARTUS_NAME

	rm -rf build
	for i in $(echo $SYSTEMS | sed "s/,/ /g"); do
		fusesoc --cores-root cores/ build $i
	done

	rm -rf $BUILD
	mv build $BUILD

	REPORT=REPORT.$QUARTUS_NAME
	echo > $REPORT
	for i in $(echo $SYSTEMS | sed "s/,/ /g"); do
		quartus_report $BUILD/${i}_0/bld-quartus | tee -a $REPORT
	done
	export PATH=$SAVE_PATH
}

build_quartus q13.0 /opt/altera/13.0/quartus/bin \
	de1-picorv32-wb-soc

exit

build_quartus q16.0 /opt/altera/16.0/quartus/bin \
	marsohod2bis-picorv32-wb-soc,marsohod3-picorv32-wb-soc,de1-soc-picorv32-wb-soc
build_quartus q13.1 /opt/altera/13.1/quartus/bin \
	marsohod2-picorv32-wb-soc,marsohod2bis-picorv32-wb-soc,de1-soc-picorv32-wb-soc
build_quartus q13.0 /opt/altera/13.0/quartus/bin \
	de1-picorv32-wb-soc,marsohod2-picorv32-wb-soc,marsohod2bis-picorv32-wb-soc,de1-soc-picorv32-wb-soc

#source /opt/xilinx/Vivado/2016.3/settings64.sh
#fusesoc --cores-root cores/ build arty
#RUNMELOG=build/arty_0/bld-vivado/arty_0.runs/synthesis/runme.log
#( awk '/^***** Vivado/ {seen = 1} seen {print} /^$/ {seen = 0}' $RUNMELOG ; \
#	awk '/^Report Instance Areas:/ {seen = 1} /^-*$/ {seen = 0} seen {print}' $RUNMELOG ; \
#	awk '/^Report Cell Usage:/ {seen = 1} seen {print} /^$/ {seen = 0}' $RUNMELOG ) > REPORT.v2016.3
#mv build build.v2016.3
