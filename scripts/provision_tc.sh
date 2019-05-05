#!/bin/bash

SAGCCANT_CMD="sagccant"
CC_CLIENT=default

## apply env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

if [ "x$TARGET_HOST" = "x" ]; then
    echo "error: variable TARGET_HOST is required...exiting!"
    exit 2;
fi

if [ "x$LICENSE_KEY_ALIAS1" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS1 (for Terracotta) is required...exiting!"
    exit 2;
fi

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Denv.CC_TEMPLATE=tc-layer/tpl-server.yaml \
              -Denv.CC_TEMPLATE_ENV=tc \
              -Denv.CC_TEMPLATE_ENV_LICENSE_KEY_ALIAS1=$LICENSE_KEY_ALIAS1 \
              -Denv.CC_TEMPLATE_ENV_TARGET_HOST=$TARGET_HOST \
              -Denv.CC_TEMPLATE_ENV_TYPE=server \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              setup

exit 0;