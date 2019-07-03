#!/bin/bash

## getting current filename and basedir
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##get the params passed-in
PREP_USER=$1
INSTALL_DIR=$2

echo "Params: $PREP_USER;$INSTALL_DIR"

## first, make sure ant is installed
yum -y install ant

##check target user
getent passwd $PREP_USER > /dev/null
if [ $? -eq 0 ]; then
    echo "$PREP_USER user exists"
else
    echo "$PREP_USER user does not exist...creating"
    useradd $PREP_USER
    passwd -l $PREP_USER
fi

## creating target directory if needed
if [ ! -d ${INSTALL_DIR} ]; then
    echo "creating install directory"
    mkdir ${INSTALL_DIR}
fi

## applying user/group on the target directory
if [ -d ${INSTALL_DIR} ]; then
    chown -R $PREP_USER:$PREP_USER $INSTALL_DIR
fi

echo "[$THIS: SUCCESS]"

exit 0;