#!/bin/bash

## getting current filename and basedir
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

## apply global env
if [ -f ${BASEDIR}/scripts/internal/provision_envs.sh ]; then
    . ${BASEDIR}/scripts/internal/provision_envs.sh
fi

##get the params passed-in
BOOTSTRAP_TARGET=$1
BOOTSTRAP_CC_PASSWORD=$2

if [ "x$BOOTSTRAP_TARGET" = "x" ]; then
    echo "Bootstrap target is empty...defaulting"
    BOOTSTRAP_TARGET=$BOOTSTRAP_TARGET_DEFAULT
fi

if [ "x$BOOTSTRAP_CC_PASSWORD" = "x" ]; then
    echo "Bootstrap CC PASSWORD is empty...defaulting."
    BOOTSTRAP_CC_PASSWORD=$BOOTSTRAP_CC_PASSWORD_DEFAULT
fi

##### bootstrap: this leverages the properties file bootstrap/$CC_BOOT.properties + apply $CC_PASSWORD if defined in setenv_cce_init_secrets
$ANT_CMD -Denv.CC_BOOT=$CC_BOOT \
    -Denv.CC_PASSWORD=$BOOTSTRAP_CC_PASSWORD \
    -Dbuild.dir=$ANT_BUILD_DIR \
    -Dinstall.dir=$INSTALL_DIR \
    $BOOTSTRAP_TARGET

runexec=$?
echo -n "Provisonning status:"
if [ $runexec -eq 0 ]; then
    echo "[$THIS: SUCCESS]"
    
    #create a setenv file to include the newly installed CLI in the PATH
    echo "export CC_CLI_HOME=${INSTALL_DIR}/CommandCentral/client" > ${HOME}/setenv-cce.sh
    echo "export PATH=\$PATH:\${CC_CLI_HOME}/bin" >> ${HOME}/setenv-cce.sh
    echo "export SAGCCANT_CMD=\"sagccant\"" >> ${HOME}/setenv-cce.sh
else
    echo "[$THIS: FAIL]"
fi

exit $runexec;