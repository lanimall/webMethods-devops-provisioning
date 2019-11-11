#!/bin/bash

## getting current filename and basedir
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

##get the commands passed-in
CMD_TARGET="${@:1}"

$SAGCCANT_CMD -f $BASEDIR/build.xml -Denv.CC_ENV=$CC_ENV $CMD_TARGET

runexec=$?
echo -n "Command status:"
if [ $runexec -eq 0 ]; then
    echo "[$THIS: $CMD_TARGET -- SUCCESS!]"
else
    echo "[$THIS: $CMD_TARGET -- FAIL!]"
fi

exit $runexec;