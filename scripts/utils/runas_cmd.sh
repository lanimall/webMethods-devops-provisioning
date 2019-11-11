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

##Command
echo "About to execute command: $CMD"

if [ "$RUN_AS_USER" == "self" ]; then
    RUN_AS_USER=$CURRENT_USER
    echo "running command as current user $RUN_AS_USER"
fi

##check target user
getent passwd $RUN_AS_USER > /dev/null
if [ $? -eq 0 ]; then
    echo "$RUN_AS_USER user exists"
else
    echo "$RUN_AS_USER user does not exist...error!"
    exit 2;
fi

##become target user for install
if [ "x$CURRENT_USER" != "x$RUN_AS_USER" ]; then
    echo "Will try to escalate with SUDO and RUN AS: $RUN_AS_USER"
    sudo $SU $RUN_AS_USER -c "$CMD"
else
    echo "Already $RUN_AS_USER! Executing command as myself!"
    exec $CMD
fi

runexec=$?
exit $runexec;