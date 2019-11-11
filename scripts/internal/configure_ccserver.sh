#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##get the params passed-in
CONFIG_ITEM=$1
CMD_UNIQUE_ID=$2

if [ "x$CONFIG_ITEM" = "x" ]; then
    echo "error: variable CONFIG_ITEM is required...exiting!"
    exit 2;
fi

case "$CONFIG_ITEM" in
  creds|licenses|repos|tuning|update)
    echo "Variable CONFIG_ITEM=$CONFIG_ITEM is valid!"
    ;;
  *)
    echo "error: variable CONFIG_ITEM is not valid. Valid values are: creds|licenses|repos|tuning|update"
    exit 2;
    ;;
esac

if [ "x$CMD_UNIQUE_ID" != "x" ]; then
    CMD_UNIQUE_ID="_$CMD_UNIQUE_ID"
fi

## build stack target file name and check if exists
CONFIG_ITEM_SCRIPT_FILE_NOEXT="configure_$CONFIG_ITEM"
if [ ! -f $BASEDIR/scripts/internal/$CONFIG_ITEM_SCRIPT_FILE_NOEXT.sh ]; then
    echo "$CONFIG_ITEM_SCRIPT_FILE_NOEXT.sh does not exist...exiting"
    exit 2;
fi

##call install script
exec $BASEDIR/scripts/internal/$CONFIG_ITEM_SCRIPT_FILE_NOEXT.sh $CMD_UNIQUE_ID "${@:3}"

runexec=$?
exit $runexec