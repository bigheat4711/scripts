#!/bin/bash 

CONTENT=$(curl -s -XGET https://stats.foldingathome.org/api/donor/bigheat4711)
CREDIT=$(echo $CONTENT | jq '.credit')
WUS=$(echo $CONTENT | jq '.wus')
echo "{ \"credit\": \"$CREDIT\", \"wus\": \"$WUS\"  }" | mosquitto_pub -l -t 'home/folding/stats'
