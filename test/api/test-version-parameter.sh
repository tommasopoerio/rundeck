#!/bin/bash

#test api version in request parameter

errorMsg() {
   echo "$*" 1>&2
}

DIR=$(cd `dirname $0` && pwd)

# accept url argument on commandline, if '-' use default
url="$1"
if [ "-" == "$1" ] ; then
    url='http://localhost:4440/api'
fi
apiurl="${url}/api"
loginurl="${url}/j_security_check"

# curl opts to use a cookie jar, and follow redirects, showing only errors
CURLOPTS="-s -S -L -c $DIR/cookies -b $DIR/cookies"
CURL="curl $CURLOPTS"


XMLSTARLET=xml

# now submit req
runurl="${apiurl}/projects"

echo "TEST: API Version in parameter..."

# get listing
params="api_version=1.2"
$CURL ${runurl}?${params} > $DIR/curl.out
if [ 0 != $? ] ; then
    errorMsg "ERROR: failed query request"
    exit 2
fi

#test curl.out for valid xml
$XMLSTARLET val -w $DIR/curl.out > /dev/null 2>&1
if [ 0 != $? ] ; then
    errorMsg "ERROR: Response was not valid xml"
    exit 2
fi

#test for expected /joblist element
$XMLSTARLET el $DIR/curl.out | grep -e '^result' -q
if [ 0 != $? ] ; then
    errorMsg "ERROR: Response did not contain expected result"
    exit 2
fi

# job list query doesn't wrap result in common result wrapper
#If <result error="true"> then an error occured.
waserror=$($XMLSTARLET sel -T -t -v "/result/@error" $DIR/curl.out)
if [ "true" == "$waserror" ] ; then
    errorMsg "Server reported an error: "
    $XMLSTARLET sel -T -t -v "/result/error/message" -n  $DIR/curl.out
    exit 2
fi
wassuccess=$($XMLSTARLET sel -T -t -v "/result/@success" $DIR/curl.out)

if [ "true" == "$wassuccess" ] ; then
    echo "OK"
else
    errorMsg "FAIL: Server did not report success"
    $XMLSTARLET sel -T -t -v "/result/error/message" -n  $DIR/curl.out
    exit 2
fi

rm $DIR/curl.out
