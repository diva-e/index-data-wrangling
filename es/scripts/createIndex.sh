#!/bin/bash

TARGET=localhost:9200/$1?pretty
echo "index target url: $TARGET with settings $2"

curl -XPUT "$TARGET"  --data-binary "@$2"
