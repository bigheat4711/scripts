#!/bin/bash

FILES="$@"
echo "md30.sh: move and delete in 30 days: $FILES"

if [ -z "$FILES" ];
then
  echo "Missing parameter";
  exit 1;
fi

for FILE in $FILES; do
  echo "move $FILE"
  if [ ! -r "$FILE" ] && [ ! -d "$FILE" ];
  then
    echo "File doesn't exist -> continue";
    continue
  fi
  
  # touch updates the timestamp of file/folder
  touch $FILE 
  test -d ~/.autodelete || mkdir ~/.autodelete
  mv -v --backup=t $FILE ~/.autodelete/
  
  if [ $? != 0 ];
  then
    echo "Can't move $FILE to ~/.autodelete/ -> continue";
    continue
  fi
done
echo "md30.sh: done"
