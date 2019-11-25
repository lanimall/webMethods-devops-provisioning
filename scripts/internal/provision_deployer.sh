#!/bin/bash

## getting current filename and basedir
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##set specific vars
TEMPLATE_PATH="sag-deployer/template.yaml"
TEMPLATE_PROPS="deployer"
TEMPLATE_ENV_TYPE="default"

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

## apply secrets used by the the install
if [ -f ${HOME}/.setenv-secrets-${THIS_NOEXT}.sh ]; then
    . ${HOME}/.setenv-secrets-${THIS_NOEXT}.sh
fi

##Command in-line Params
if [ "x$TARGET_HOSTS" = "x" ]; then
    echo "error: variable TARGET_HOSTS is required...exiting!"
    exit 2;
fi

if [ "x$LICENSE_KEY_ALIAS_IS" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS_IS is required...exiting!"
    exit 2;
fi

if [ "x$DEFAULT_ADMIN_PASSWORD_IS" = "x" ]; then
    echo "error: Variable DEFAULT_ADMIN_PASSWORD_IS is required...exiting!"
    exit 2;
fi

if [ "x$FIXES_DEPLOYER" = "x" ]; then
    echo "warning: variable FIXES_DEPLOYER is empty...no fixes will be applied"
    FIXES_DEPLOYER="[]"
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
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOSTS \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              -Denv.CC_TEMPLATE=$TEMPLATE_PATH \
              -Denv.CC_ENV=$TEMPLATE_PROPS \
              -Denvironment.type=$TEMPLATE_ENV_TYPE \
              -Dtarget.nodes=$TARGET_HOSTS \
              -Ddeployer.key.license.alias=$LICENSE_KEY_ALIAS_IS \
              -Ddeployer.fixes=$FIXES_DEPLOYER \
              -Ddeployer.administrator.password=$DEFAULT_ADMIN_PASSWORD_IS \
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