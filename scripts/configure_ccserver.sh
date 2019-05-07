#!/bin/bash

SAGCCANT_CMD="sagccant"

##### apply repos, licenses, mirrors, etc...

## Make sure that the various variables needed (eg. CC_SAG_REPO_USR, CC_SAG_REPO_PWD etc...) are defined in the shell
## or in the predefined setenv file: ${HOME}/setenv-cce.sh

## apply env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

##apply default command central license
$SAGCCANT_CMD -Denv.CC_ENV=cc \
                -Dlicenses.zip.url=https://github.com/SoftwareAG/sagdevops-cc-server/blob/release/104apr2019/licenses/licenses.zip?raw=true \
                licenses

##apply custom product licenses
if [ -f ${HOME}/sag_licenses.zip ]; then
    $SAGCCANT_CMD -Denv.CC_ENV=cc \
                -Dlicenses.zip.url="file://${HOME}/sag_licenses.zip" \
                licenses
fi

$SAGCCANT_CMD -Denv.CC_TEMPLATE=sag-cc-creds  \
                -Denv.CC_TEMPLATE_ENV=sag-cc-creds \
                -Denv.CC_SAG_REPO_USR="$CC_SAG_REPO_USR"  \
                -Denv.CC_SAG_REPO_PWD="$CC_SAG_REPO_PWD" \
                -Denv.CC_SSH_USER="$CC_SSH_USER" \
                -Denv.CC_SSH_KEY_FILENAME="$CC_SSH_KEY_FILENAME" \
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

##create/update a file in tmp to broadcast that the script is done
filename=$0
filename="${filename%.*}"
touch /tmp/$filename.done.status