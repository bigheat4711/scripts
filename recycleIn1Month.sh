#!/bin/sh

if [ -z "$1" ];
then
  echo "Missing parameter";
  exit 1;
fi

if [ ! -r $1 ];
then
  echo "File doesn't exist";
  exit 1;
fi

output=$1
set -x
mv $output ~/nethome/autodelete/
set +x

if [ $? != 0 ];
then
  echo "Can't move file to ~/nethome/autodelete/";
  exit 1;
fi
