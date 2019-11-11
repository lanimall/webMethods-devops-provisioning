#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

##get the params passed-in
RUN_AS_USER=$1
INSTALL_DIR=$2

if [ "x$RUN_AS_USER" = "x" ]; then
    echo "error: variable RUN_AS_USER is required...exiting!"
    exit 2;
fi

if [ "x$INSTALL_DIR" = "x" ]; then
    echo "error: Variable INSTALL_DIR is required...exiting!"
    exit 2;
fi

##executes the pre-requisites as root
$BASEDIR/scripts/utils/runas_cmd.sh root "$BASEDIR/scripts/internal/provision_ccserver_prereqs.sh $RUN_AS_USER $INSTALL_DIR"

exit;