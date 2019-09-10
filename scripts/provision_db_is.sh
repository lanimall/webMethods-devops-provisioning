#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/.."

$BASEDIR/scripts/utils/provision_wrapper.sh $THIS_NOEXT "$@"
runexec=$?

exit $runexec