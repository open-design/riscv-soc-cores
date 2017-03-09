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

build_vivado()
{
	VIVADO_NAME=$1
	VIVADO_PATH=$2

	SYSTEM=$3

	source ${VIVADO_PATH}/settings64.sh

	rm -rf build
	fusesoc --cores-root cores/ build ${SYSTEM}

	T=build/${SYSTEM}_0/bld-vivado/${SYSTEM}_0.runs
	RUNMELOG=${T}/synthesis/runme.log
	if [ ! -e ${RUNMELOG} ]; then
		RUNMELOG=${T}/synth_1/runme.log
	fi

	( awk '/^***** Vivado/ {seen = 1} seen {print} /^$/ {seen = 0}' $RUNMELOG ; \
		awk '/^Report Instance Areas:/ {seen = 1} /^-*$/ {seen = 0} seen {print}' $RUNMELOG ; \
		awk '/^Report Cell Usage:/ {seen = 1} seen {print} /^$/ {seen = 0}' $RUNMELOG ) \
		| sed "s/ \+$//" > REPORT.${VIVADO_NAME}

	mv build build.${VIVADO_NAME}
}

#build_vivado v2017.1 /opt/xilinx/2017.1/Vivado/2017.1 \
#	arty-picorv32-wb-soc
#
#build_vivado v2016.3 /opt/xilinx/2013.3/Vivado/2013.3 \
#	arty-picorv32-wb-soc

build_quartus q16.0 /opt/altera/16.0/quartus/bin \
	marsohod2bis-picorv32-wb-soc,marsohod3-picorv32-wb-soc
build_quartus q13.1 /opt/altera/13.1/quartus/bin \
	marsohod2-picorv32-wb-soc,marsohod2bis-picorv32-wb-soc
