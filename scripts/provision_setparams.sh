#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

## apply global env
if [ -f ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh ]; then
    . ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh
fi

PROVISIONING_STACK=$1
PARAM_NAME=$2
PARAM_VALUE=$3
APPEND_EXISTING=$4

if [ "x$APPEND_EXISTING" = "x" ]; then
    APPEND_EXISTING="false"
fi

PROVISION_SCRIPT_FILENAME_NOEXT="provision_${PROVISIONING_STACK}"
SETENV_FILE_PARAMS="~/setenv-${PROVISION_SCRIPT_FILENAME_NOEXT}.sh"

FILE_REDIRECTION=">"
if [ "$APPEND_EXISTING" = "true" ]; then
    FILE_REDIRECTION=">>"
fi

CMD="echo \"export ${PARAM_NAME}=${PARAM_VALUE}\" ${FILE_REDIRECTION} ${SETENV_FILE_PARAMS}"

##become target user for command
$BASEDIR/scripts/utils/runas_cmd.sh $RUN_AS_USER "$CMD"
runexec=$?
exit $runexec