#!/bin/bash

CC_ENV=default
RUN_AS_USER="saguser"

## getting filename without path and extension
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

$BASEDIR/scripts/runas_cmd.sh $RUN_AS_USER "$BASEDIR/scripts/internal/ccserver_cmd.sh $CC_ENV startcc waitcc"

runexec=$?
exit $runexec;