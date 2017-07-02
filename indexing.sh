#!/bin/sh

cat _site/lunr.json | node build-index.js > index.json