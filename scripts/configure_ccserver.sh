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

##get the params passed-in
CMD_UNIQUE_ID=$1
if [ "x$CMD_UNIQUE_ID" != "x" ]; then
    CMD_UNIQUE_ID="_$CMD_UNIQUE_ID"
fi

##become target user for install
$BASEDIR/scripts/utils/runas_cmd.sh $RUN_AS_USER "$BASEDIR/scripts/internal/configure_ccserver.sh"

##create/update a file in tmp to broadcast that the script is done
touch /tmp/$THIS_NOEXT.done.status$CMD_UNIQUE_ID