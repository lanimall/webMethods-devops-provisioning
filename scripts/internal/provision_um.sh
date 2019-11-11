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

## apply script specific env (where things needed for the provisoning are needed, like TARGET_HOST etc...)
if [ -f ${HOME}/setenv-${THIS_NOEXT}.sh ]; then
    . ${HOME}/setenv-${THIS_NOEXT}.sh
fi

##Command in-line Params
STATUS_ID=$1
if [ "x$STATUS_ID" != "x" ]; then
    STATUS_ID="_$STATUS_ID"
fi

if [ "x$TARGET_HOST" = "x" ]; then
    echo "error: variable TARGET_HOST is required...exiting!"
    exit 2;
fi

if [ "x$LICENSE_KEY_ALIAS1" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS1 (for UM) is required...exiting!"
    exit 2;
fi

##### apply template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Dbuild.dir=$ANT_BUILD_DIR \
              -Dinstall.dir=$INSTALL_DIR \
              -Drepo.product=$CC_REPO_NAME_PRODUCTS \
              -Drepo.fix=$CC_REPO_NAME_FIXES \
              -Dbootstrap.install.dir=$INSTALL_DIR \
              -Dbootstrap.install.installer.version=$CC_BOOTSTRAPPER_VERSION \
              -Dbootstrap.install.installer.version.fix=$CC_BOOTSTRAPPER_VERSION_FIX \
              -Denv.CC_TEMPLATE=um-layer/tpl-server.yaml \
              -Denv.CC_ENV=um \
              -Denvironment.type=server \
              -Dum.host=$TARGET_HOST \
              -Dum.host2=$TARGET_HOST \
              -Dum.host3=$TARGET_HOST \
              -Dum.provisioning.host=$TARGET_HOST \
              -Dum.license.key.alias=$LICENSE_KEY_ALIAS1 \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              setup_noclean

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