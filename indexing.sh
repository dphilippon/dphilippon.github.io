#!/bin/sh

cat lunr.json | node build-index.js > index.json
cat lunr.operators.json | node build-index.js > index_operator.json