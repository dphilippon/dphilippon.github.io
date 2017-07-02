#!/bin/sh

cat _site/lunr.json | node build-index.js > _site/index.json