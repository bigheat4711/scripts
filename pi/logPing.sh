#!/bin/bash

while sleep 3;
do 
  LINE=$(timeout 1 ping -c1 -4 8.8.8.8)
  RC=$?
  
  if [ $RC -eq 0 ];
  then
    MS=$(echo $LINE | grep -oP ".*time=\K\d+")
  else
    MS=1000
  fi
  echo $MS | mosquitto_pub -l -t home/online/ping;
done
