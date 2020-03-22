#!/bin/bash

# Quellen: https://superuser.com/questions/1289496/why-is-inotifywait-m-running-multiple-times-infinite-loop

test -z $1 && { echo "Missing first parameter: FILE to watch."; exit 1; }
test -z "$2" && { echo "Missiong second parameter: ACTION to execution on file change."; exit 2; }
FILE=$1
ACTION=$2

#ls $FILE >/dev/null || 
test -f $FILE || { echo "FILE '$FILE' NOT FOUND" && exit 1; }

inotifywait -m -e close_write $FILE 2>/dev/null | while read IGNORE 
  do echo `$ACTION`;
done

#z.B.
#while ! inotifywait -e close_write docker-compose.yml ; do docker-compose up; done
