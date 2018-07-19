#!/bin/bash

ANT_CMD="ant"

CC_BOOT=default
SPM_INSTALL_DIR=/opt/softwareag

## first, make sure ant is installed
sudo yum -y install ant

# bootstrap the SPM agent
$ANT_CMD -Denv.CC_BOOT=$CC_BOOT -Dinstall.dir=$SPM_INSTALL_DIR agent

# once done, make sure to run this script to install SPM as a service
sudo sh $SPM_INSTALL_DIR/bin/afterInstallAsRoot.sh

#re-source the bashrc file now it's been updated with CC client bin in PATH
. $HOME/.bashrc