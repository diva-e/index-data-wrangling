#!/bin/bash

curl http://localhost:8983/solr/films2/schema -X POST -H 'Content-type:application/json' --data-binary '{
    "add-field" : {
        "name":"name_copy",
        "type":"text_general",
        "multiValued":false,
        "stored":true
    },
    "add-copy-field":{
        "source":"name",
        "dest":[ "name_copy" ]
    }
}'
