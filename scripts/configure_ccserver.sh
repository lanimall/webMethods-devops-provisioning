#!/bin/bash

SAGCCANT_CMD="sagccant"

##### apply repos, licenses, mirrors, etc...
## Make sure that EMPOWER_PSW and EMPOWER_PSW are defined in the shell $HOME/.bashrc or $HOME/.bash_profile
## or provide them here -DEMPOWER_PSW= -DEMPOWER_PSW=

CC_SSH_KEY_PATH=${HOME}/.ssh/id_rsa
CC_SSH_KEY_PWD=
CC_SSH_USER=centos

## apply env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

$SAGCCANT_CMD apply_licenses

$SAGCCANT_CMD -Denv.CC_TEMPLATE=sag-cc-creds  \
                -Denv.CC_TEMPLATE_ENV=sag-cc-creds \
                -Denv.CC_SAG_REPO_USR="$CC_SAG_REPO_USR"  \
                -Denv.CC_SAG_REPO_PWD="$CC_SAG_REPO_PWD" \
                -Denv.CC_SSH_USER="$CC_SSH_USER" \
                -Denv.CC_SSH_KEY_PATH="$CC_SSH_KEY_PATH" \
                -Denv.CC_SSH_KEY_PWD="$CC_SSH_KEY_PWD" \
                -Denv.CC_PASSWORD="$CC_PASSWORD" \
                setup

$SAGCCANT_CMD -Denv.CC_TEMPLATE=sag-cc-repos  \
                -Denv.CC_TEMPLATE_ENV=sag-cc-repos \
                setup

$SAGCCANT_CMD -Denv.CC_TEMPLATE=sag-cc-tuneup  \
                -Denv.CC_TEMPLATE_ENV=cc \
                setup

$SAGCCANT_CMD -Denv.CC_TEMPLATE=sag-cc-update  \
                -Denv.CC_TEMPLATE_ENV=cc \
                setup