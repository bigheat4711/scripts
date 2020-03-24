#!/bin/bash

output=/home/cgrau/EVENTS.lst

function printDate () {
  date "+%F %T " | tr -d "\n" >> $output;
}

result=$(/home/cgrau/projects/scripts/updates/coursePlayVersion.sh)
echo $result
if [ $result != "v4.01" ] ; then
  printDate
  text="FOUND NEW COURSE PLAY VERSION $result";
  echo $text >> $output;
  /usr/bin/zenity --info --title="checkEvents" --text="$text" --display=:0.0;
fi

#result=$(/home/cgrau/projects/scripts/updates/ls17UpdateVersion.pl)
#echo $result
#if [ $result != "1.3.1" ] ; then
  #printDate
  #text="FOUND NEW LS17 UPDATE VERSION $result";
  #echo $text >> $output;
  #/usr/bin/zenity --info --title="checkEvents" --text="$text" --display=:0.0;
#fi

#result=$(/home/cgrau/projects/scripts/updates/wildfly-maven-plugin.pl)
#echo $result
#if [ $result != "16" ] ; then
#  printDate
#  text="FOUND NEW wildfly-maven-plugin UPDATE VERSION $result";
#  echo $text >> $output;
#  /usr/bin/zenity --info --title="checkEvents" --text="$text" --display=:0.0;
#fi
