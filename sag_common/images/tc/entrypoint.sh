#!/bin/sh
set -e

# if managed image (SPM is present)
if [ -d $SAG_HOME/profiles/SPM/bin ]; then
    # self-register
    $SAG_HOME/profiles/SPM/bin/register.sh
    # start SPM in background
    $SAG_HOME/profiles/SPM/bin/startup.sh
fi

echo "Remove old logs"
rm -rf $SAG_HOME/Terracotta/server/wrapper/logs/*

# start in background
$SAG_HOME/Terracotta/server/wrapper/bin/tsa-service start

echo "TC process started. Waiting ..."
# wait until TC server.log comes up
while [  ! -f $SAG_HOME/Terracotta/server/wrapper/logs/terracotta-server.log ]; do
    tail $SAG_HOME/Terracotta/server/wrapper/logs/wrapper-tsa.log
    sleep 5
done

# this is our main container process
echo "TC is ONLINE"
tail -f $SAG_HOME/Terracotta/server/wrapper/logs/terracotta-server.log
