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

if [ "x$LICENSE_KEY_ALIAS1" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS1 (for IS) is required...exiting!"
    exit 2;
fi

if [ "x$LICENSE_KEY_ALIAS2" = "x" ]; then
    echo "error: Variable LICENSE_KEY_ALIAS2 (for Terracotta) is required...exiting!"
    exit 2;
fi

## env variables
export db_type="oracle"
export db_name="XE"
export db_sid="XE"
export db_host="sagdevops_ccinfra_db"
export db_port="1521"
export db_username="is_dbuser"
export db_password="strong123!"

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Dinstall.dir=$SPM_INSTALL_DIR \
              -Denv.CC_TEMPLATE=is-layer/tpl_is_stateful_messaging.yaml \
              -Denv.CC_TEMPLATE_ENV=is_stateful_messaging \
              -Denv.CC_TEMPLATE_ENV_LICENSE_KEY_ALIAS1=$LICENSE_KEY_ALIAS1 \
              -Denv.CC_TEMPLATE_ENV_LICENSE_KEY_ALIAS2=$LICENSE_KEY_ALIAS2 \
              -Denv.CC_TEMPLATE_ENV_TARGET_HOST=$TARGET_HOST \
              -Denv.CC_TEMPLATE_ENV_TYPE=server \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              setup

##create/update a file in tmp to broadcast that the script is done
filename=$0
filename="${filename%.*}"
touch /tmp/$filename.done.status

exit 0;