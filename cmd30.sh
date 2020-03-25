#!/bin/bash

FILES="$@"
echo "cmd30.sh: compress, move and delete in 30 days: $FILES"

if [ -z "$FILES" ];
then
  echo "Missing parameter";
  exit 1;
fi

for FILE in $FILES; do
  echo "Compress $FILE"
  #echo "$FILE will be compressed, moved to ~/nethome/autodelete/ and deleted in 30 days.";
  if [ ! -r $FILE ];
  then
    echo "File doesn't exist -> continue";
    continue
  fi

  FILE_COMPRESSED=$FILE.tar.gz
  tar czf $FILE_COMPRESSED $FILE

  if [ $? != 0 ];
  then
    echo "Couldn't execute: tar czf $FILE_COMPRESSED $FILE -> continue"
    continue
  fi
done
echo "cmd30.sh: (1/2) done"

for FILE in $FILES; do
  FILES_COMPRESSSED=( "${FILES_COMPRESSSED[@]}" "$FILE".tar.gz )
done

~/projects/scripts/md30.sh "${FILES_COMPRESSSED[@]}"
rm -rf $FILE;
echo "cmd30.sh: (2/2) done"
