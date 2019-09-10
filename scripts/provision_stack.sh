#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

## get stack name
PROVISION_STACK_NAME="$1"

if [ "x$PROVISION_STACK_NAME" = "x" ]; then
    echo "error: variable PROVISION_STACK_NAME is required...exiting!"
    exit 2;
fi

## build target file
PROVISION_SCRIPT_FILE_NOEXT="provision_${PROVISION_STACK_NAME}"

## check if stack name correspond to an existing target file
if [ ! -f $BASEDIR/scripts/internal/$PROVISION_SCRIPT_FILE_NOEXT.sh ]; then
    echo "error: variable PROVISION_STACK_NAME is required...exiting!"
    exit 2;
fi

$BASEDIR/scripts/utils/provision_wrapper.sh $PROVISION_SCRIPT_FILE_NOEXT "${@:2}"
runexec=$?

exit $runexec