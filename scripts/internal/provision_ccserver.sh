#!/bin/bash

ANT_CMD="ant"
ANT_BUILD_DIR=${HOME}/sagcc/build

## getting current filename and basedir
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##get the params passed-in
CC_BOOT=$1
INSTALL_DIR=$2
BOOTSTRAP_TARGET=$3

echo "Params: $CC_BOOT;$INSTALL_DIR;$BOOTSTRAP_TARGET"

## apply env with secrets
## for security, CC_PASSWORD should be defined in this setenv_cce_init_secrets the shell 
if [ -f ${HOME}/setenv_cce_init_secrets.sh ]; then
    echo "applying cce secrets to the shell"
    . ${HOME}/setenv_cce_init_secrets.sh
fi

##### bootstrap: this leverages the properties file bootstrap/$CC_BOOT.properties + apply $CC_PASSWORD if defined in setenv_cce_init_secrets
$ANT_CMD -Denv.CC_BOOT=$CC_BOOT -Denv.CC_PASSWORD=$CC_PASSWORD -Dbuild.dir=$ANT_BUILD_DIR -Dinstall.dir=$INSTALL_DIR $BOOTSTRAP_TARGET

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