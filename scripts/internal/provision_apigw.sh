#!/bin/bash

SAGCCANT_CMD="sagccant"
CC_CLIENT=default
INSTALL_DIR=/opt/softwareag
ANT_BUILD_DIR=${HOME}/sagcc/build
CC_BOOTSTRAPPER_VERSION=10.3
CC_BOOTSTRAPPER_VERSION_FIX=fix7
CC_REPO_NAME_PRODUCTS=webMethods-10.3
CC_REPO_NAME_FIXES=Empower

## apply env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

if [ "x$TARGET_HOST" = "x" ]; then
    echo "error: variable TARGET_HOST is required...exiting!"
    exit 2;
fi

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Dbuild.dir=$ANT_BUILD_DIR \
              -Dinstall.dir=$INSTALL_DIR \
              -Denv.CC_TEMPLATE=apigw-layer/tpl_server.yaml \
              -Denv.CC_ENV=apigw \
              -Dbootstrap.install.dir=$INSTALL_DIR \
              -Drepo.product=$CC_REPO_NAME_PRODUCTS \
              -Drepo.fix=$CC_REPO_NAME_FIXES \
              -Dbootstrap.install.installer.version=$CC_BOOTSTRAPPER_VERSION \
              -Dbootstrap.install.installer.version.fix=$CC_BOOTSTRAPPER_VERSION_FIX \
              -Denvironment.type=server \
              -Dapigw.host=$TARGET_HOST \
              -Dapigw.is.instance.type=integrationServer \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              setup

runexec=$?
exit $runexec;