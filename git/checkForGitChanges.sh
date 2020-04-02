#!/bin/bash

FOLDERS=`find -maxdepth 2 -type d -name .git`

for f in $FOLDERS; do cd $f; cd ..; pwd; git status -s; cd ..; echo; done
