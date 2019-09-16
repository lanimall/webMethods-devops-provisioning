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

if [ "x$TARGET_HOST2" = "x" ]; then
    echo "error: variable TARGET_HOST2 is required...exiting!"
    exit 2;
fi

if [ "x$TARGET_HOST3" = "x" ]; then
    echo "error: variable TARGET_HOST3 is required...exiting!"
    exit 2;
fi

if [ "x$LICENSE_KEY_ALIAS1" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS1 (for UM) is required...exiting!"
    exit 2;
fi

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Denv.CC_TEMPLATE=um-layer \
              -Denv.CC_TEMPLATE_ENV=um \
              -Denv.CC_TEMPLATE_ENV_LICENSE_KEY_ALIAS1=$LICENSE_KEY_ALIAS1 \
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

##create/update a file in tmp to broadcast that the script is done
filename=$0
filename="${filename%.*}"
touch /tmp/$filename.done.status

exit 0;