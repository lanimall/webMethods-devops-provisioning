#!/bin/bash

## getting base dir
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

##get the params passed-in
RUN_AS_USER=$1

if [ "x$RUN_AS_USER" = "x" ]; then
    RUN_AS_USER="self"
fi

$BASEDIR/scripts/provision_cce.sh $RUN_AS_USER boot "${@:2}"