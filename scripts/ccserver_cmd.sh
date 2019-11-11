#!/bin/bash

## getting filename without path and extension
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

##get the params passed-in
RUN_AS_USER=$1
CMD="${@:2}"

if [ "x$RUN_AS_USER" = "x" ]; then
    RUN_AS_USER="self"
fi

$BASEDIR/scripts/utils/runas_cmd.sh $RUN_AS_USER "$BASEDIR/scripts/internal/$THIS_NOEXT.sh $CMD"

runexec=$?
exit $runexec;