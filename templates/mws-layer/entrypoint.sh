#!/bin/sh

# if managed image (SPM is present)
if [ -d $SAG_HOME/profiles/SPM/bin ]; then
    # self-register
    $SAG_HOME/profiles/SPM/bin/register.sh
    # start SPM in background
    $SAG_HOME/profiles/SPM/bin/startup.sh
fi

# you can simply run main product run in foreground
# $SAG_HOME/profiles/MWS_$INSTANCE_NAME/bin/console.sh
# or do this...

echo "Remove old logs"
rm -rf $SAG_HOME/profiles/MWS_$INSTANCE_NAME/logs/*
rm -rf $SAG_HOME/MWS/server/$INSTANCE_NAME/logs/*

# or can start in background
$SAG_HOME/profiles/MWS_$INSTANCE_NAME/bin/startup.sh

echo "MWS process started. Waiting ..."

# wait until IS server.log comes up
while [  ! -f $SAG_HOME/MWS/server/$INSTANCE_NAME/logs/_full_.log ]; do
    tail $SAG_HOME/profiles/MWS_$INSTANCE_NAME/logs/wrapper.log
    sleep 5
done

# this is our main container process
echo "MWS is ONLINE at http://`hostname`:8585/"
tail -f $SAG_HOME/MWS/server/$INSTANCE_NAME/logs/_full_.log
