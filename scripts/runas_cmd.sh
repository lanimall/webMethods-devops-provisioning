#!/bin/bash

RUN_AS_USER=$1
CMD="${@:2}"

CURRENT_USER=`id -nu`

# For SELinux we need to use 'runuser' not 'su'
if [ -x "/sbin/runuser" ]; then
    SU="/sbin/runuser"
else
    SU="/bin/su"
fi

##check target user
getent passwd $RUN_AS_USER > /dev/null
if [ $? -eq 0 ]; then
    echo "$RUN_AS_USER user exists"
else
    echo "$RUN_AS_USER user does not exist...error!"
    exit 2;
fi

##Command
echo "About to execute command: $CMD"

##become target user for install
if [ "x$CURRENT_USER" != "x$RUN_AS_USER" ]; then
    echo "Will RUN AS: $RUN_AS_USER"
    sudo $SU $RUN_AS_USER -c "$CMD"
else
    echo "Executing command as $CURRENT_USER"
    exec $CMD
fi

runexec=$?
exit $runexec;