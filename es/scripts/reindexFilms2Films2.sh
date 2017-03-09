#!/bin/bash

curl -XPOST 'localhost:9200/_reindex?pretty' -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "films"
  },
  "dest": {
    "index": "films2"
  }
}
'
