#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

PROVIONING_KEY=$1
PARAM_NAME=$2
PARAM_VALUE=$3

PROVISION_SCRIPT_FILENAME_NOEXT="provision_${PROVIONING_KEY}"
SETENV_FILE_PARAMS="~/setenv-${PROVISION_SCRIPT_FILENAME_NOEXT}.sh"
CMD="echo \"export ${PARAM_NAME}=${PARAM_VALUE}\" > ${SETENV_FILE_PARAMS}"

##become target user for command
$BASEDIR/scripts/utils/runas_cmd.sh $RUN_AS_USER "$CMD"
runexec=$?
exit $runexec