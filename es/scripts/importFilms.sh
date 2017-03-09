#!/bin/bash



curl -XPOST 'localhost:9200/films/_bulk?pretty' -H "charset=UTF-8"  --data-binary "@$1"
