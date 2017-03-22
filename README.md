# Index Data Wrangling Solr und Elasticsearch
Materialien zum Vortrag zum Nachstellen und Ausprobieren. 

## Voraussetzungen
Die Demos laufen auf einem Ubuntu 16.10
* aktuelles docker und docker-compose
* für ES bulk Import der Demodaten wird [jq](https://stedolan.github.io/jq/) für Konvertierung benötigt, wenn man die Konvertierung der solr Demodaten selbst nachvollziehen will

## Vorbereitung Solr 
Es wird eine solr Installation im Demo-Verzeichnisbaum benutzt. Diese wird über das install-Skript in `./install/` erstellt.

Anschließend müssen die Cores erzeugt werden. Dafür gibt es ein Skript in `solr/scripts/setup/`.

### DataImportHandler
Im Core `films2` wird der DIH konfiguriert. Dafür müssen in der `solrconfig.xml` neben den Änderungen aus dem Vortrag einige jars eingetragen werden.
Die Datei findet sich in `solr/solr-6.4.x/server/solr/films2/conf/`

Die Zeilen sehen aus wie folgt:

```xml
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-\d.*\.jar" />
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-extras-\d.*\.jar" />
```
und werden zu der Liste ab Zeile 80 hinzugefügt.

Der RequestHandler
```xml
  <requestHandler name="/dataimport" class="solr.DataImportHandler">
    <lst name="defaults">
      <str name="config">solr-data-config.xml</str>
      <str name="update.chain">initial-import</str>
    </lst>
  </requestHandler>

 <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          UpdateRequestProcessorChain
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
  <updateRequestProcessorChain name="initial-import">
          <processor class="solr.IgnoreFieldUpdateProcessorFactory">
                  <str name="fieldRegex">_version_</str>
          </processor>
          <processor class="solr.RunUpdateProcessorFactory" />
  </updateRequestProcessorChain>
```

Der Abschnitt wird vor den ersten `<RequestHandler>` eingefügt.

Eine Datei solr-data-config.xml muss neben der solrconfig.xml angelegt werden, mit folgendem Inhalt:

```xml
<dataConfig>
  <document>
    <entity name="sep" processor="SolrEntityProcessor"
            url="http://127.0.0.1:8983/solr/films"
            query="*:*"/>
  </document>
</dataConfig>
```

Nach den Änderungen muss solr neu gestartet werden mit `solr/solr-6.4.x/bin/solr restart`.

Danach ist solr bereit zur Demo.


## Vorbereitung Elasticsearch

Vor dem Start von ES muss ein Kernelparameter angepasst werden.
```
sudo sysctl -w vm.max_map_count=262144
```

Für permanentes Setzen
```
$ grep vm.max_map_count /etc/sysctl.conf
vm.max_map_count=262144
```

Vor dem Start von Elasticsearch müssen Schreibrechte auf Verzeichnis `es/elasticsearch/data` mit 
```
chmod a+x es/elasticsearch/data
```
gegeben werden. 
Der ES Cluster wird gestartet in Verzeichnis `/es/docker-compose/es` mit Kommando
```
sudo docker-compose up
```

Es wird ebenfalls ein Admintool für ES gestartet, `cerebro`, das läuft unter [localhost:9000](http://localhost:9000).
Für die Verbindung mit dem ES-Cluster wird eingegeben:  `http://esmaster:9200`


Für Elasticsearch müssen die Indexe angelegt und die Mappings für Indexe `films` und `films2` eingespielt werden. Dafür gibt es Skripte in
`es/scripts`

Es wird ein Beispiel analog zu Solr films benutzt. Die Dokumente wurden für den Import mit `jq` für das Elasticsearch Bulk-API in Form gebracht.  

Indexe `films` und `films2` anlegen mit
```
./createIndex.sh films indexmappingsfilms.json
./createIndex.sh films2 indexmappingsfilms2.json
```

Dokumente laden mit
```
./importFilms.sh es_films.json
```

Danach ist Elasticsearch bereit zur Demo.

