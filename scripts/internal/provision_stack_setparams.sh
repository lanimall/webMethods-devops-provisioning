#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##get the params passed-in
STACK_NAME=$1
PARAM_NAME=$2
PARAM_VALUE=$3
APPEND_EXISTING=$4

if [ "x$APPEND_EXISTING" = "x" ]; then
    APPEND_EXISTING="false"
fi

PROVISION_SCRIPT_FILENAME_NOEXT="provision_$STACK_NAME"
SETENV_FILE_PARAMS="$HOME/setenv-$PROVISION_SCRIPT_FILENAME_NOEXT.sh"

if [ "$APPEND_EXISTING" = "true" ]; then
    echo "export $PARAM_NAME=\"$PARAM_VALUE\"" >> $SETENV_FILE_PARAMS
else
    echo "export $PARAM_NAME=\"$PARAM_VALUE\"" > $SETENV_FILE_PARAMS
fi

runexec=$?
exit $runexec