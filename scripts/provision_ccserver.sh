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
STATUS_ID=$1
BOOTSTRAP_TARGET=$2

if [ "x$STATUS_ID" = "x" ]; then
    #apply now date/time in milli precision to the STATUSID
    STATUS_ID=`date +%Y%m%d_%H%M%S%3N`
fi

##executes the pre-requisites as root
$BASEDIR/scripts/utils/runas_cmd.sh root "$BASEDIR/scripts/internal/provision_ccserver_prereqs.sh $RUN_AS_USER $INSTALL_DIR"

##become target user for install
$BASEDIR/scripts/utils/runas_cmd.sh $RUN_AS_USER "$BASEDIR/scripts/internal/provision_ccserver.sh $BOOTSTRAP_TARGET"

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
    touch /tmp/$THIS_NOEXT.done.status_$STATUS_ID
else
    echo "[$THIS: FAIL]"

    ##create/update a file in tmp to broadcast that the script is done
    touch /tmp/$THIS_NOEXT.fail.status_$STATUS_ID
fi

exit;