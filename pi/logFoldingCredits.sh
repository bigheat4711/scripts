#!/bin/bash 

while true; 
do 
  curl -s -XGET https://stats.foldingathome.org/api/donor/bigheat4711 | jq ".credit" | mosquitto_pub -l -t 'home/folding/credits'
  sleep 900
done
