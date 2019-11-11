#!/bin/bash

## getting current filename and basedir
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

## apply global env
if [ -f ${BASEDIR}/scripts/conf/setenv_cce_globals.sh ]; then
    . ${BASEDIR}/scripts/conf/setenv_cce_globals.sh
fi

## apply globals overrides
if [ -f ${HOME}/.setenv_cce_globals.sh ]; then
    . ${HOME}/.setenv_cce_globals.sh
fi

## apply secrets
if [ -f ${HOME}/.setenv_cce_secrets.sh ]; then
    . ${HOME}/.setenv_cce_secrets.sh
fi

##get the params passed-in
BOOTSTRAP_TARGET=$1
STATUS_ID=$2

if [ "x$BOOTSTRAP_TARGET" = "x" ]; then
    echo "error: variable BOOTSTRAP_TARGET is required...exiting!"
    exit 2;
fi

##check if CC_PASSWORD set (should be in .setenv_cce_secrets.sh)
if [ "x$CC_PASSWORD" = "x" ]; then
    echo "error: variable CC_PASSWORD is required...exiting!"
    exit 2;
fi

if [ "x$STATUS_ID" != "x" ]; then
    STATUS_ID="_$STATUS_ID"
fi

#build the installer name
CC_INSTALLER="cc-def-${CC_BOOTSTRAPPER_VERSION}-${CC_BOOTSTRAPPER_VERSION_FIX}-${CC_BOOTSTRAPPER_PLATFORM}"

##### bootstrap: this leverages the properties file bootstrap/$CC_BOOT.properties + apply $CC_PASSWORD if defined in setenv_cce_init_secrets
$ANT_CMD -Denv.CC_BOOT=$CC_BOOT \
    -Denv.CC_PASSWORD=$CC_PASSWORD \
    -Denv.CC_INSTALLER=$CC_INSTALLER \
    -Dbuild.dir=$ANT_BUILD_DIR \
    -Dinstall.dir=$INSTALL_DIR \
    $BOOTSTRAP_TARGET

runexec=$?
if [ $runexec -eq 0 ]; then
    echo "[$THIS: SUCCESS]"
    
    #create a setenv file to include the newly installed CLI in the PATH
    echo "export CC_CLI_HOME=${INSTALL_DIR}/CommandCentral/client" > ${HOME}/setenv-cce.sh
    echo "export PATH=\$PATH:\${CC_CLI_HOME}/bin" >> ${HOME}/setenv-cce.sh
    echo "export SAGCCANT_CMD=\"sagccant\"" >> ${HOME}/setenv-cce.sh

    ##create/update a file in home to possibly broadcast that the script is done
    touch ${HOME}/$THIS_NOEXT.status.success$STATUS_ID
else
    echo "[$THIS: FAIL]"
    
    ##create/update a file in home to possibly broadcast that the script failed
    touch ${HOME}/$THIS_NOEXT.status.fail$STATUS_ID
fi

exit $runexec;