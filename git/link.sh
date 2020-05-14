#!/bin/bash

FILES=( checkForGitChanges.sh pullGitChanges.sh )
TARGET_FOLDER=../..
echo "FILES=${FILES[@]}"
echo "TARGET_FOLDER=$TARGET_FOLDER"
echo


for FILE in "${FILES[@]}";
do
    test -d $TARGET_FOLDER || { echo "ERROR: Target folder $TARGET_FOLDER doesn't exist"; exit 1; }
    readlink -f $FILE; test -f $FILE || { echo "ERROR: File to link $FILE doesn't exist"; exit 2; }
    test -f $TARGET_FOLDER/$FILE && echo -n "File exists. Replace? [ENTER]" && read && { mkdir ~/.autodelete; cp -v --backup=t $TARGET_FOLDER/$FILE ~/.autodelete; }
    ln -s $PWD/$FILE $TARGET_FOLDER/$FILE && echo done && echo
done

