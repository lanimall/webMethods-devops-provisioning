#!/bin/bash

## getting current filename and base path
THIS=`basename $0`
THIS_NOEXT="${THIS%.*}"
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
BASEDIR="$THISDIR/../.."

##get the params passed-in
STACK_NAME=$1
STATUS_ID=$2

if [ "x$STACK_NAME" = "x" ]; then
    echo "error: variable STACK_NAME is required...exiting!"
    exit 2;
fi

function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
#function join_by { local IFS="$1"; shift; echo "$*"; }

## build an array of allowed names
stacknames=()
for f in $THISDIR/provision_*; do
  filename=$(basename $f)
  filename_noext="${filename%.*}"
  stackname_toadd=$(echo $filename_noext | sed "s/provision_//")
  stacknames+=( $stackname_toadd );
done


# check if arr contains value
if [[ " ${stacknames[@]} " =~ " ${STACK_NAME} " ]]; then
    echo "Variable CONFIG_ITEM=$STACK_NAME is valid!"
fi

# check if arr does not contains value
if [[ ! " ${stacknames[@]} " =~ " ${STACK_NAME} " ]]; then
    # whatever you want to do when arr doesn't contain value
    valid_values=$(join_by ' , ' ${stacknames[@]})
    echo "error: variable STACK_NAME is not valid. Valid values are: $valid_values"
    exit 2;
fi

## build stack target file name and check if exists
STACK_SCRIPT_FILE_NOEXT="provision_$STACK_NAME"
if [ ! -f $BASEDIR/scripts/internal/$STACK_SCRIPT_FILE_NOEXT.sh ]; then
    echo "$STACK_SCRIPT_FILE_NOEXT.sh does not exist...exiting"
    exit 2;
fi

##call install script
exec $BASEDIR/scripts/internal/$STACK_SCRIPT_FILE_NOEXT.sh $STATUS_ID ${@:3}

runexec=$?
exit $runexec