#!/bin/bash

## getting filename without path and extension
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

## apply global env
if [ -f ${BASEDIR}/scripts/conf/setenv_cce_globals.sh ]; then
    . ${BASEDIR}/scripts/conf/setenv_cce_globals.sh
fi

## apply globals overrides
if [ -f ${HOME}/.setenv_cce_globals.sh ]; then
    . ${HOME}/.setenv_cce_globals.sh
fi

## apply cce env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

## apply secrets
if [ -f ${HOME}/.setenv_cce_secrets.sh ]; then
    . ${HOME}/.setenv_cce_secrets.sh
fi

##Command in-line Params
STATUS_ID=$1
if [ "x$STATUS_ID" != "x" ]; then
    STATUS_ID="_$STATUS_ID"
fi

echo "Trying to tune Command Central settings and timeout"
$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-tuneup  \
                -Denv.CC_ENV=cc \
                setup

runexec=$?
if [ $runexec -eq 0 ]; then
    echo "[$THIS_NOEXT: SUCCESS]"
    
    ##create/update a file in tmp to broadcast that the script is done
    touch ${HOME}/$THIS_NOEXT.status.success$STATUS_ID
else
    echo "[$THIS_NOEXT: FAIL]"
    
    ##create/update a file in tmp to broadcast that the script is done
    touch ${HOME}/$THIS_NOEXT.status.fail$STATUS_ID
fi

exit $runexec;