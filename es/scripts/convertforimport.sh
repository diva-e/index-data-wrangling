#!/bin/bash

jq -c '.[] | { index: { _type: "movie" } },. ' 
