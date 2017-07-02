#!/bin/sh

lunr-index-build -r id -f title:10 -f body lunr.json index.json
echo '[{ "id": "1", "title": "Foo", "body": "Bar" }]' | node build-index.js > index.json