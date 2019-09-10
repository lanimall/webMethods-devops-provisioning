#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

## apply global env
if [ -f ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh ]; then
    . ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh
fi

##get the params passed-in
PROVISION_SCRIPT_FILE_NOEXT=$1
STATUS_ID=$2
if [ "x$STATUS_ID" = "x" ]; then
    #apply now date/time in milli precision to the STATUSID
    STATUS_ID=`date +%Y%m%d_%H%M%S%3N`
fi

if [ "x$PROVISION_SCRIPT_FILE_NOEXT" = "x" ]; then
    echo "PROVISION_SCRIPT_FILE_NOEXT is empty...exiting"
    exit 2;
fi

if [ ! -f $BASEDIR/scripts/internal/$PROVISION_SCRIPT_FILE_NOEXT.sh ]; then
    echo "$PROVISION_SCRIPT_FILE_NOEXT.sh does not exist...exiting"
    exit 2;
fi

##become target user for install
$BASEDIR/scripts/utils/runas_cmd.sh $RUN_AS_USER "$BASEDIR/scripts/internal/$PROVISION_SCRIPT_FILE_NOEXT.sh"
runexec=$?

echo -n "Provisonning status:"
if [ $runexec -eq 0 ]; then
    echo "[$PROVISION_SCRIPT_FILE_NOEXT: SUCCESS]"
    ##create/update a file in tmp to broadcast that the script is done
    touch /tmp/$PROVISION_SCRIPT_FILE_NOEXT.done.status_$STATUS_ID
else
    echo "[$PROVISION_SCRIPT_FILE_NOEXT: FAIL]"
    ##create/update a file in tmp to broadcast that the script is done
    touch /tmp/$PROVISION_SCRIPT_FILE_NOEXT.fail.status_$STATUS_ID
fi

exit $runexec