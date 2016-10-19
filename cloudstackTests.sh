#!/bin/bash

# 2016-10-19
# Nicolas Vazquez
# --------------------------------------------------------------------------------------------------------------------------
# Script for CloudStack marvin tests
# --------------------------------------------------------------------------------------------------------------------------

display_help(){
	echo "Usage: cloudstackTests [options]"
	echo
	echo "Options:"
	echo "  -h            show this help message and exit"
	echo "  -l            specify marvin logs directory, Default: /tmp/MarvinLogs"
	echo "  -r            specify results directory, Default: /tmp/MarvinResults"
	echo "  -t            specify tests directory, Default: test/integration/smoke"
}

LOGDIR=/tmp/MarvinLogs
#rm -rf $LOGDIR/*

TESTS_DIR=test/integration/smoke
TIMESTAMP_FORMATTED=`date +"%Y%m%d%H%M"`
RESULTS_DIR=/tmp/MarvinResults
#mkdir -p $RESULTS_DIR
#mkdir -p $RESULTS_DIR/$TIMESTAMP_FORMATTED-TEST-SUITE
RESULTS_FILE=$RESULTS_DIR/$TIMESTAMP_FORMATTED-TEST-SUITE/results.log
FAILURES_FILE=$RESULTS_DIR/$TIMESTAMP_FORMATTED-TEST-SUITE/failures.log

#test_suite=`ls $TESTS_DIR/test_*.py`
#number_tests=`ls $TESTS_DIR/test_*.py | wc -l`
#date=`date +"%Y-%m-%d %H:%M:%S"`
#echo "$date) $number_tests tests ro run" >> $RESULTS_FILE

# getopts tutorial
# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts 'h:l:r:t' option; do
	case "$option" in
	h) 	display_help
		exit
		;;
	l)	LOGDIR=$OPTARG
		;;
	r)	RESULTS_DIR=$OPTARG
		;;
	t)	TESTS_DIR=$OPTARG
		;;
	\?)	echo "Invalid option"
		exit
		;;
	esac
done

counter=0
for file in $test_suite; do
	date=`date +"%Y-%m-%d %H:%M:%S"`
	echo "$date) Running test file: $file" >> $RESULTS_FILE
	nosetests --with-marvin --marvin-config=setup/dev/advanced.cfg -vv -s -a tags=advanced --hypervisor=vmware $file ;
	counter=$((counter+1))
done

GOOD=0
BAD=0
for dir in $LOGDIR/*/; do
	if [[ -s ${dir}failed_plus_exceptions.txt ]]; then
		BAD=$((BAD+1))
		cat ${dir}failed_plus_exceptions.txt >> $FAILURES_FILE
	else
		GOOD=$((GOOD+1))
		cat ${dir}results.txt >> $RESULTS_FILE
	fi
done

echo "Ran $counter tests: $GOOD OK, $BAD failed" >> $RESULTS_FILE
