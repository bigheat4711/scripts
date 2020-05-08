#!/bin/bash

# timeout 3s ping -w 1 web.de >/dev/null; echo "{ \"online\":\"$?\" }"  | mosquitto_pub -l -t home/online
ping -q -c 1 -W 1 8.8.8.8 >/dev/null; echo "{ \"offline\":\"$?\" }"  | mosquitto_pub -l -t home/online/status
