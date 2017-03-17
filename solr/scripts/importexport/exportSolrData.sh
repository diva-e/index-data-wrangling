#!/bin/bash

SOLR_URL=$1


docsPerFile=300
query=*:*

TIMESTAMP=$( date +%Y%m%d%H%M%S )
baseFilename=solr-dump-$TIMESTAMP

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

solr_export() {
    require_variable SOLR_URL
    echo "solr url is: $SOLR_URL"

    docCount=`curl -s "$SOLR_URL/select?q=$query&rows=0&wt=json"  | sed -r 's/.*"numFound":([0-9]+).*/\1/'`

    echo
    echo "Found $docCount documents."

    pageCount=$(($docCount/$docsPerFile))
    remainder=$(($docCount % $docsPerFile))

    # might not have been a clean division. check if we have to do one last page check...
    if [ $remainder != 0 ]; then
	let pageCount=pageCount+1
    fi

    echo "Anzahl der Dumpfiles: " $pageCount
    echo
    echo

    pageNumber=0
    while [ $pageNumber -lt $pageCount ]; do
	offset=$(($pageNumber * $docsPerFile))
	let pageNumber=pageNumber+1

	outputFilename="$baseFilename-$pageNumber.json.gz"
	echo "Writing file: " $outputFilename

	PARAMS="$SOLR_URL/select?q=$query&wt=json&start=$offset&rows=$docsPerFile"
	# echo curl $PARAMS
	curl -s "$PARAMS" | sed -r 's/[^[]*(\[.+\])}}/\1/' | sed -r 's/,"_version_":[0-9]+|"_version_":[0-9]+,//g' | gzip -c > $outputFilename
    done

}



START=$(date +%s%N)

solr_export

END=$(date +%s%N)
DIFF=$(( (END - START)/1000000000))

echo "took $DIFF secs"
echo "export finished"
