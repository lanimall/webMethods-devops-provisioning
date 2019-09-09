#!/bin/bash

RUN_AS_USER="saguser"
INSTALL_DIR=/opt/softwareag

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

## get params for bootstrap command target
BOOTSTRAP_TARGET=$1
if [ "x$BOOTSTRAP_TARGET" = "x" ]; then
    echo "Bootstrap target is empty...defaulting to server"
    BOOTSTRAP_TARGET="boot"
fi
echo "Bootstrap target: $BOOTSTRAP_TARGET"

##executes the pre-requisites as root
$BASEDIR/scripts/runas_cmd.sh root "$BASEDIR/scripts/internal/provision_ccserver_prereqs.sh $RUN_AS_USER $INSTALL_DIR"

##become target user for install
$BASEDIR/scripts/runas_cmd.sh $RUN_AS_USER "$BASEDIR/scripts/internal/provision_ccserver.sh $BOOTSTRAP_TARGET"

runexec=$?
echo -n "Provisonning status:"
if [ $runexec -eq 0 ]; then
    echo "[$THIS: SUCCESS]"
    
    # once done, make sure to run this script to install SPM as a service
    if [ -f $INSTALL_DIR/bin/afterInstallAsRoot.sh ]; then
        echo "Executing afterInstallAsRoot"
        $BASEDIR/scripts/runas_cmd.sh root "sh $INSTALL_DIR/bin/afterInstallAsRoot.sh"
        echo "afterInstallAsRoot done!"
    else
        echo "Warning: No afterInstallAsRoot file found..."
    fi

    ##create/update a file in tmp to broadcast that the script is done
    touch /tmp/$THIS_NOEXT.done.status
else
    echo "[$THIS: FAIL]"

    ##create/update a file in tmp to broadcast that the script is done
    touch /tmp/$THIS_NOEXT.fail.status
fi

exit;