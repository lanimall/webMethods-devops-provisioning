#!/bin/bash

## getting base dir
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

$BASEDIR/scripts/provision_ccserver.sh client