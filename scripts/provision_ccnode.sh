#!/bin/bash

ANT_CMD="ant"

CC_BOOT=default
SPM_INSTALL_DIR=/opt/softwareag

## first, make sure ant is installed
sudo yum -y install ant

# bootstrap the SPM agent
$ANT_CMD -Denv.CC_BOOT=$CC_BOOT -Denv.CC_PASSWORD=$CC_PASSWORD -Dinstall.dir=$SPM_INSTALL_DIR agent

# once done, make sure to run this script to install SPM as a service
sudo sh $SPM_INSTALL_DIR/bin/afterInstallAsRoot.sh

#create a setenv file to include the newly installed CLI in the PATH
echo "export CC_CLI_HOME=${SPM_INSTALL_DIR}/CommandCentral/client" > ${HOME}/setenv-cce.sh
echo "export PATH=\$PATH:\${CC_CLI_HOME}/bin" >> ${HOME}/setenv-cce.sh
echo "export SAGCCANT_CMD=\"sagccant\"" >> ${HOME}/setenv-cce.sh