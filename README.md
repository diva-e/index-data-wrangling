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
Im Core films2 wird der DIH konfiguriert. Dafür müssen in der solrconfig neben den Änderungen aus dem Vortrag einige jars eingegtragen werden.

Die Zeilen sehen aus wie folgt:

```xml
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-\d.*\.jar" />
  <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-extras-\d.*\.jar" />
```
und werden am besten zu der Liste ab Zeile 80 hinzugefügt.

## Vorbereitung Elasticsearch