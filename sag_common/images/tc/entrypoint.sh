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


# before starting the terracotta server, we update the tc-config.xml configuration file
CONFIG_XML="$SAG_HOME/Terracotta/server/wrapper/conf/tc-config.xml"
#sed -i.bak -r 's/OFFHEAP_ENABLED/'$OFFHEAP_ENABLED'/; s/OFFHEAP_MAX_SIZE/'$OFFHEAP_MAX_SIZE'/; s/TC_SERVER1/'$TC_SERVER1'/g; s/TC_SERVER2/'$TC_SERVER2'/g' $CONFIG_XML

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
