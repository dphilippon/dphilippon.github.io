#!/bin/sh

tail -n +4 _site/lunr.json | node build-index.js > index.json