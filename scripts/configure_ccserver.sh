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

##become target user for install
$BASEDIR/scripts/runas_cmd.sh $RUN_AS_USER "$BASEDIR/scripts/internal/configure_ccserver.sh"

##create/update a file in tmp to broadcast that the script is done
touch /tmp/$THIS_NOEXT.done.status