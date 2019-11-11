#!/bin/bash

## getting base dir
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

##get the params passed-in
INSTALL_DIR=$1

# once done, make sure to run this script to install SPM as a service
if [ -f $INSTALL_DIR/bin/afterInstallAsRoot.sh ]; then
    echo "Executing afterInstallAsRoot"
    $BASEDIR/scripts/utils/runas_cmd.sh root "sh $INSTALL_DIR/bin/afterInstallAsRoot.sh"
    echo "afterInstallAsRoot done!"
else
    echo "Warning: No afterInstallAsRoot file found..."
fi