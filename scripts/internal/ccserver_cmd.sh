#!/bin/bash

## getting current filename and basedir
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

## apply global env
if [ -f ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh ]; then
    . ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh
fi

##get the commands passed-in
CC_ENV=$1
CMD_TARGET="${@:2}"

## apply env if file is there
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

$SAGCCANT_CMD -f $BASEDIR/build.xml -Denv.CC_ENV=$CC_ENV $CMD_TARGET

runexec=$?
echo -n "Command status:"
if [ $runexec -eq 0 ]; then
    echo "[$THIS: SUCCESS]"
else
    echo "[$THIS: FAIL]"
fi

exit $runexec;