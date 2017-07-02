#!/bin/sh

echo "$(cat lunr.json)" | node build-index.js > index.json