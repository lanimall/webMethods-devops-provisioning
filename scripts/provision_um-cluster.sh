#!/bin/bash

SAGCCANT_CMD="sagccant"
CC_CLIENT=default
TARGET_HOST=sagdevops_ccinfra_um
TARGET_HOST2=sagdevops_ccinfra_um2
TARGET_HOST3=sagdevops_ccinfra_um3

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
              -Denv.CC_TEMPLATE=um-layer \
              -Denv.CC_TEMPLATE_ENV=um \
              -Denv.CC_TEMPLATE_ENV_TARGET_HOST=$TARGET_HOST \
              -Denv.CC_TEMPLATE_ENV_TARGET_HOST2=$TARGET_HOST2 \
              -Denv.CC_TEMPLATE_ENV_TARGET_HOST3=$TARGET_HOST3 \
              -Denv.CC_TEMPLATE_ENV_TYPE=cluster \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              -Denv.SOCKET_CHECK_TARGET_HOST2=$TARGET_HOST2 \
              -Denv.SOCKET_CHECK_TARGET_PORT2=22 \
              -Denv.SOCKET_CHECK_TARGET_HOST3=$TARGET_HOST3 \
              -Denv.SOCKET_CHECK_TARGET_PORT3=22 \
              setup