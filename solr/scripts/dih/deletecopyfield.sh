#!/bin/bash

curl http://localhost:8983/solr/films2/schema  -X POST -H 'Content-type:application/json' --data-binary '{
   "delete-copy-field":{ "source":"name", "dest":"name_copy" },
   "delete-field":{ "name":"name_copy" }
}'
