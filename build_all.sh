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

SOC=-picorv32-wb-soc

build_quartus q13.0 /opt/altera/13.0/quartus/bin \
	core-ep2c5${SOC},de1${SOC},de0-nano${SOC},marsohod2${SOC},marsohod2bis${SOC}
build_quartus q13.1 /opt/altera/13.1/quartus/bin \
	de0-nano${SOC},marsohod2${SOC},marsohod2bis${SOC}
build_quartus q16.1 /opt/altera/16.1/quartus/bin \
	de0-nano${SOC},marsohod2bis${SOC},marsohod3${SOC}
build_quartus q17.0 /opt/altera/17.0/quartus/bin \
	de0-nano${SOC},marsohod2bis${SOC},marsohod3${SOC}
