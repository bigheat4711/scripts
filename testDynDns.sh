#!/bin/bash

nslookup -query=AAAA dualstack.ddnss.ch && notify-send "success $LINENO"
nslookup -query=AAAA ipv6.ddnss.ch && notify-send "success $LINENO"
nslookup -query=AAAA manman.ddnss.de && notify-send "success $LINENO"
nslookup -query=AAAA dext.ddnss.org && notify-send "success $LINENO"
