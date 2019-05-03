#!/bin/bash

SAGCCANT_CMD="sagccant"
CC_CLIENT=default
SPM_INSTALL_DIR=/opt/softwareag

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
              -Dinstall.dir=$SPM_INSTALL_DIR \
              -Denv.CC_TEMPLATE=is-layer/tpl_is_stateless.yaml \
              -Denv.CC_TEMPLATE_ENV=is \
              -Denv.CC_TEMPLATE_ENV_TARGET_HOST=$TARGET_HOST \
              -Denv.CC_TEMPLATE_ENV_TYPE=server \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              setup

exit 0;