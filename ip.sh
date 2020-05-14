#!/bin/bash

curl 'https://api.ipify.org?format=json'
# or
curl -s 'https://api.ipify.org?format=json' | jq .ip
# or
curl -s 'https://api.ipify.org?format=json' | jq .ip | tr -d '"'
