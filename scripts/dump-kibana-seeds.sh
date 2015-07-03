#!/bin/bash

elasticdump \
  --input=http://localhost:9200/kibana-int \
  --output=kibana-seeds.json \
  --type=data
