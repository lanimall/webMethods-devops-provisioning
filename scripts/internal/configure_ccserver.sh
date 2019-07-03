#!/bin/bash

SAGCCANT_CMD="sagccant"
ANT_BUILD_DIR=${HOME}/sagcc/build

## getting filename without path and extension
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##### apply repos, licenses, mirrors, etc...

## Make sure that the various variables needed (eg. CC_SAG_REPO_USR, CC_SAG_REPO_PWD etc...) are defined in the shell
## or in the predefined setenv file: ${HOME}/setenv-cce.sh

## apply env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

## apply env with secrets
## for security, CC_PASSWORD should be defined in this setenv_cce_init_secrets the shell 
if [ -f ${HOME}/setenv_cce_init_secrets.sh ]; then
    echo "applying cce secrets to the shell"
    . ${HOME}/setenv_cce_init_secrets.sh
fi

##apply default command central license
$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_ENV=cc \
                -Dlicenses.zip.url=https://github.com/SoftwareAG/sagdevops-cc-server/blob/release/104apr2019/licenses/licenses.zip?raw=true \
                licenses

##apply custom product licenses
if [ -f ${HOME}/sag_licenses.zip ]; then
    $SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                    -Denv.CC_ENV=cc \
                    -Dlicenses.zip.url="file://${HOME}/sag_licenses.zip" \
                    licenses
fi

echo "CC_SAG_REPO_USR=$CC_SAG_REPO_USR"

$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-creds  \
                -Denv.CC_ENV=sag-cc-creds \
                -Dsag.repo.username="$CC_SAG_REPO_USR"  \
                -Dsag.repo.password="$CC_SAG_REPO_PWD" \
                -Dssh.user.name="$CC_SSH_USER" \
                -Dssh.pk.filename="$CC_SSH_KEY_FILENAME" \
                -Dssh.pk.password="$CC_SSH_KEY_PWD" \
                -Dcc.password="$CC_PASSWORD" \
                setup

$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-repos  \
                -Denv.CC_ENV=sag-cc-repos \
                setup

$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-tuneup  \
                -Denv.CC_ENV=cc \
                setup

$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-update  \
                -Denv.CC_ENV=cc \
                setup
