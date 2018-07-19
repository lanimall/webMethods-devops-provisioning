#!/bin/bash

SOURCE_PATH="../"
TARGET_USER="centos"
TARGET_HOST="aws_centos7_sagdevops_ccinfra_cce"
TARGET_PATH="~/sagdevops_provisioning"

function rsyncfull() { rsync -arv --exclude '.git' --exclude '.idea' --exclude 'logs' --exclude '.DS_Store' --exclude '.classpath' --exclude '.settings' --exclude 'target/' --delete "$@";}

## sync remotely first
echo "Syncing content between $TARGET_HOST:$TARGET_PATH "
rsyncfull $SOURCE_PATH $TARGET_USER@$TARGET_HOST:$TARGET_PATH