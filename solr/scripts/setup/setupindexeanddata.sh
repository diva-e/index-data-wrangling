#!/bin/bash

SOLR_HOME=../../solr-6.4.2

$SOLR_HOME/bin/solr stop
rm $SOLR_HOME/server/logs/*.log
rm -Rf $SOLR_HOME/server/solr/films/
$SOLR_HOME/bin/solr start
$SOLR_HOME/bin/solr create -c films
$SOLR_HOME/bin/solr create -c films2

curl http://localhost:8983/solr/films/schema -X POST -H 'Content-type:application/json' --data-binary '{
    "add-field" : {
        "name":"name",
        "type":"text_general",
        "multiValued":false,
        "stored":true
    },
    "add-field" : {
        "name":"initial_release_date",
        "type":"tdate",
        "stored":true
    }
}'

curl http://localhost:8983/solr/films2/schema -X POST -H 'Content-type:application/json' --data-binary '{
    "add-field" : {
        "name":"name",
        "type":"text_general",
        "multiValued":false,
        "stored":true
    },
    "add-field" : {
        "name":"initial_release_date",
        "type":"tdate",
        "stored":true
    }
}'



$SOLR_HOME/bin/post -c films $SOLR_HOME/example/films/films.json

curl http://localhost:8983/solr/films/config/params -H 'Content-type:application/json'  -d '{
"update" : {
  "facets": {
    "facet.field":"genre"
    }
  }
}'


curl http://localhost:8983/solr/films/config/params -H 'Content-type:application/json'  -d '{
"set" : {
  "browse": {
    "hl":"on",
    "hl.fl":"name"
    }
  }
}'
