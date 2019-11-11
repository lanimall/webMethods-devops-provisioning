#!/bin/bash

## getting filename without path and extension
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

##get the params passed-in
RUN_AS_USER=$1

$BASEDIR/scripts/ccserver_cmd.sh "$RUN_AS_USER" startcc waitcc

runexec=$?
exit $runexec;