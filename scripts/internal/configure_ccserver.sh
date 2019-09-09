#!/bin/bash

## getting filename without path and extension
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##### apply repos, licenses, mirrors, etc...

## Make sure that the various variables needed (eg. CC_SAG_REPO_USR, CC_SAG_REPO_PWD etc...) are defined in the shell
## or in the predefined setenv file: ${HOME}/setenv-cce.sh

## apply global env
if [ -f ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh ]; then
    . ${BASEDIR}/scripts/conf/setenv_webmethods_provisioning.sh
fi

## apply cce env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

## apply secrets
if [ -f ${HOME}/.setenv_cce_secrets.sh ]; then
    . ${HOME}/.setenv_cce_secrets.sh
fi

##check if CC_PASSWORD set
if [ "x$CC_PASSWORD" = "x" ]; then
    echo "Bootstrap CC_PASSWORD is empty...defaulting."
    CC_PASSWORD=$BOOTSTRAP_CC_PASSWORD_DEFAULT
fi

##apply default command central license
echo "Trying to apply default command central license"
$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_ENV=cc \
                -Dlicenses.zip.url=https://github.com/SoftwareAG/sagdevops-cc-server/blob/release/104apr2019/licenses/licenses.zip?raw=true \
                licenses

##apply custom product licenses
echo "Trying to add custom product licenses to Command Central"
if [ -f ${HOME}/sag_licenses.zip ]; then
    $SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                    -Denv.CC_ENV=cc \
                    -Dlicenses.zip.url="file://${HOME}/sag_licenses.zip" \
                    licenses
fi

echo "Trying to setup credentials into Command Central"
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

echo "Trying to setup product and fix repositories in Command Central"
$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-repos  \
                -Denv.CC_ENV=sag-cc-repos \
                setup

echo "Trying to tune Command Central settings and timeout"
$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-tuneup  \
                -Denv.CC_ENV=cc \
                setup

echo "Trying to update Command Central"
$SAGCCANT_CMD  -Dbuild.dir=$ANT_BUILD_DIR \
                -Denv.CC_TEMPLATE=sag-cc-update  \
                -Denv.CC_ENV=cc \
                setup
