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

##check if CC_PASSWORD set (should be in .setenv_cce_secrets.sh)
if [ "x$CC_PASSWORD" = "x" ]; then
    echo "error: variable CC_PASSWORD is required...exiting!"
    exit 2;
fi

echo "Trying to setup credentials into Command Central"
$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-creds  \
                -Denv.CC_ENV=sag-cc-creds \
                -Dsag.repo.username="$CC_SAG_REPO_USR"  \
                -Dsag.repo.password="$CC_SAG_REPO_PWD" \
                -Dssh.user.name="$CC_SSH_USER" \
                -Dssh.pk.filename="$CC_SSH_KEY_FILENAME" \
                -Dssh.pk.password="$CC_SSH_KEY_PWD" \
                -Dcc.password="$CC_PASSWORD" \
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