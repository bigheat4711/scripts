#!/bin/bash
# by Claudio Grau

SERVICE=${1:-'https://localhost:8443'}
SERVICE_LOGIN=${2:-'https%3A%2F%2Flocalhost%3A8443%2Flogin'}
CAS_URL=${3:-https://stage.login.1and1.org/ims-sso/login?service=$SERVICE_LOGIN}
echo SERVICE=$SERVICE
echo SERVICE_LOGIN=$SERVICE_LOGIN
echo CAS_URL=$CAS_URL
echo

HOST=`echo -n $SERVICE | cut -d':' -f2 | tr -d '/'`
PORT=`echo -n $SERVICE | cut -d':' -f3`
  nc -zvw 2 $HOST $PORT || { echo "No service running at $SERVICE" && exit 1; }

echo "1) get 'execution' field from CAS"
EXECUTION=`curl "$CAS_URL" -s 2>/dev/null | xpath -q -e 'string(//input[@name="execution"]/@value)'`
echo "   EXECUTION.length=$(echo -n $EXECUTION | wc -c)"
test -z "$EXECUTION" && echo '$EXECUTION' is empty && exit 1
echo


CAS_USERNAME=`grep mapstools.cas.service-user     ~/.spring-boot-devtools.properties -m1 | cut -d':' -f2 | sed 's/ //g'`
CAS_PASSWORD=`grep mapstools.cas.service-password ~/.spring-boot-devtools.properties -m1 | cut -d':' -f2 | sed 's/ //g'`
echo '2) do CAS login to get TICKET (OTP) with:'
echo "   CAS_USERNAME=$CAS_USERNAME"
echo "   CAS_PASSWORD=$CAS_PASSWORD"
TICKET=`curl -XPOST "$CAS_URL" --data "username=$CAS_USERNAME&password=$CAS_PASSWORD&execution=$EXECUTION&_eventId=submit&geolocation=" -v -s 2>&1 | grep -Fi "< Location" | cut -d' ' -f3 | cut -d'=' -f2 | sed 's/[^[:print:]]//g' `
echo "   TICKET=$TICKET"
test -z "$TICKET" && echo '$TICKET' is empty && exit 2
echo


echo '3) Send TICKET to SERVICE to retrieve session'
curl -XGET "$SERVICE/login?ticket=$TICKET" -D cookie-jar -k -q #2>/dev/null 
SESSION=`grep SESSION cookie-jar  | cut -d':' -f2 | sed 's/ //g'`
echo "   $SESSION"
test -z "$SESSION" && echo "$SESSION is empty. Retry might work." && exit 3
echo


echo '4) CAS/SSO session cookie is stored in cookie-jar. Just add "-b cookie-jar" to your curl commands to use this session. Like:'
echo "   $ curl -XGET '$SERVICE/api/leakedcredentials' -b cookie-jar -k"
