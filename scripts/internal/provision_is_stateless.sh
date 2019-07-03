#!/bin/bash

SAGCCANT_CMD="sagccant"
CC_CLIENT=default
INSTALL_DIR=/opt/softwareag
ANT_BUILD_DIR=${HOME}/sagcc/build

## apply env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

if [ "x$TARGET_HOST" = "x" ]; then
    echo "error: variable TARGET_HOST is required...exiting!"
    exit 2;
fi

if [ "x$LICENSE_KEY_ALIAS1" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS1 (for IS) is required...exiting!"
    exit 2;
fi

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Dbuild.dir=$ANT_BUILD_DIR \
              -Dinstall.dir=$INSTALL_DIR \
              -Denv.CC_TEMPLATE=is-layer/tpl_is_stateless.yaml \
              -Denv.CC_ENV=is \
              -Dis.host=$TARGET_HOST \
              -Denvironment.type=server \
              -Dis.license.key.alias=$LICENSE_KEY_ALIAS1 \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              setup

runexec=$?
exit $runexec;