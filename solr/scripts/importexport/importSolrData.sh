#!/bin/bash

SOLR_URL=$1
baseFilename=$2

error() {
	echo $1 >&2
	exit 1
}

require_variable() {
	while [[ $# -gt 0 ]]; do
		local variable_name=$1
		eval "[[ \$$variable_name ]]" || error "$variable_name is not set!"
		shift
	done
}


solr_import() {
    require_variable SOLR_URL
    require_variable baseFilename

    
    pageNumber=0
    while [ 1 = 1 ]; do
	let pageNumber=pageNumber+1

	inputFilename="$baseFilename-$pageNumber.json.gz"
	if [ -e $inputFilename ]
	then
	    echo "Reading file " $inputFilename
	    PARAMS="$SOLR_URL/update/json?commit=true"
	    gunzip -c $inputFilename | curl -s -d @- -H 'Content-type:application/json; charset=utf-8'  "$PARAMS"
	else
	    echo "all files read"
	    break
	fi
    done
}


### start time
START=$(date +%s%N)

solr_import

END=$(date +%s%N)
DIFF=$(( (END - START)/1000000000))
echo "took $DIFF secs"
echo
echo
echo "Import finished"

