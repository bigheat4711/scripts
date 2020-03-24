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

echo "File $1 will be compressed and moved to ~/nethome/autodelete/. It will be deleted in 30 days.";

echo "Compressing file/folder $1";
output=$1.tar.gz
tar czf $output $1
if [ $? != 0 ];
then
  echo "Can't compress file/folder";
  exit 1;
fi

~/projects/scripts/recycleIn1Month.sh $output

echo "Deleting original file/folder";
rm -rf $1;
