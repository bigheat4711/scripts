#!/bin/bash
#!/bin/bash

output=/home/cgrau/EVENTS.lst

function printDate () {
  date "+%F %T " | tr -d "\n" >> $output;
}

result=$(curl -I http://ac1accmobservboss01.server.lan:8380/sim-number-service-v1.3/version.json 2>/dev/null | head -n1 | cut -d' ' -f2)
#echo $result
if [ $result != "404" ] ; then
  printDate
  text="New Version available, status code $result";
  echo $text >> $output;
  /usr/bin/zenity --info --title="checkEventsFast" --text="$text" --display=:0.0;
fi
