#!/bin/bash

SOLR_VERSION=6.4.2

if [ -d "../solr/solr-$SOLR_VERSION" ]
then
    echo Solr Installation gefunden. Nichts zu tun.
    exit 1
fi

# download solr
if [ ! -f "solr-$SOLR_VERSION.tgz"  ]
then
    echo
    wget http://mirror.dkd.de/apache/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz
else
    echo solr Archiv vorhanden
fi    

# untar into solr dir
if [ -f "solr-$SOLR_VERSION.tgz"  ]
then
    echo solr-$SOLR_VERSION.tgz  auspacken nach ../solr/
    tar xzf solr-$SOLR_VERSION.tgz -C ../solr/
    echo fertig.
else
    echo Archiv solr-$SOLR_VERSION.tgz scheint zu fehlen?
fi

