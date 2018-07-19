#!/bin/bash

SAGCCANT_CMD="sagccant"
CC_CLIENT=default
TARGET_HOST=sagdevops_ccinfra_is

##### apply um template
$SAGCCANT_CMD -Denv.CC_CLIENT=$CC_CLIENT \
              -Denv.CC_TEMPLATE=is-layer/tpl_is_stateless_messaging.yaml \
              -Denv.CC_TEMPLATE_ENV=is \
              -Denv.CC_TEMPLATE_ENV_TARGET_HOST=$TARGET_HOST \
              -Denv.CC_TEMPLATE_ENV_TYPE=server \
              -Denv.SOCKET_CHECK_TARGET_HOST=$TARGET_HOST \
              -Denv.SOCKET_CHECK_TARGET_PORT=22 \
              setup