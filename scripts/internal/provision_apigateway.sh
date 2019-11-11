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

if [ "x$TARGET_HOST" = "x" ]; then
    echo "error: variable TARGET_HOST is required...exiting!"
    exit 2;
fi

if [ "x$LICENSE_KEY_ALIAS_APIGW" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS_APIGW (for Api Gateway) is required. Check [${HOME}/setenv-${THIS_NOEXT}.sh] for list of included variables."
    exit 2;
fi

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Dbuild.dir=$ANT_BUILD_DIR \
              -Dinstall.dir=$INSTALL_DIR \
              -Drepo.product=$CC_REPO_NAME_PRODUCTS \
              -Drepo.fix=$CC_REPO_NAME_FIXES \
              -Dbootstrap.install.dir=$INSTALL_DIR \
              -Dbootstrap.install.installer.version=$CC_BOOTSTRAPPER_VERSION \
              -Dbootstrap.install.installer.version.fix=$CC_BOOTSTRAPPER_VERSION_FIX \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOSTS \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              -Denv.CC_TEMPLATE=sag-apigw-layer/tpl_server.yaml \
              -Denv.CC_ENV=apigw \
              -Denvironment.type=default \
              -Dtarget.nodes=$TARGET_HOSTS \
              -Dagw.key.license.alias=$LICENSE_KEY_ALIAS_APIGW \
              -Dagw.is.instance.type=integrationServer \
              -Dagw.fixes=ALL \
              setup_noclean

runexec=$?

STATUS_ID=$1
if [ "x$STATUS_ID" != "x" ]; then
    STATUS_ID="_$STATUS_ID"
fi

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