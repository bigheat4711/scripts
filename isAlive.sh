#!/bin/bash
status=$(curl -I http://accmobservboss.server.lan:8280/mobile-support-v2.2/rest/check/alive 2>/dev/null | head -n1 | cut -f2 -d' ')
#echo $status
test $status == 404 && zenity --info --title='Event' --text='mapi 2.2 offline' --display=:0.0
