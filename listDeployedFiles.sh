#!/bin/bash

echo "Looking for content in all slot?/applications on jboss@conclearboss1";

while read slot; do ssh -n jboss@conclearboss1 "find /home/jboss/${slot}/applications/" -type f 2>/dev/null ; done < slots.lst ;
#echo Result written to file $file;
