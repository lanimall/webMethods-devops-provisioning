#!/bin/sh

# if managed image (SPM is present)
if [ -d $SAG_HOME/profiles/SPM/bin ]; then
    # self-register
    $SAG_HOME/profiles/SPM/bin/register.sh
    # start SPM in background
    $SAG_HOME/profiles/SPM/bin/startup.sh
fi



# Remove configuration and state
if [ "$START_CLEAN" == "true" ]; then
  echo "Cleaning UM State"
  rm -f `find $UM_HOME/ -name *.jks`
  rm -rf $UM_HOME/server/$REALM/data/
fi

# The first time the server is run, the data will be a total blank slate. We can live with that, except we want to restore the default *@*
# full ACL.
if [[ ! -e server/umserver/data ]]
then
	echo '*@*' > server/$REALM/bin/secfile.conf
fi

# Create a new service based on the default script that starts UM in the background while keeping it compatible with Command Central start/stop abilities
START_SCRIPT=$UM_HOME/server/umserver/bin/umservice
if [ ! -f $START_SCRIPT ] ; then
   echo "Creating startup script"
   cp -rf $UM_HOME/server/umserver/bin/nserver $START_SCRIPT
   sed -i.bak -e '/FIXED_COMMAND=console/ s/^#*/#/' $START_SCRIPT
fi

# start UM
/bin/sh $START_SCRIPT start

echo "UM process started. Waiting ..."
# wait until TC server.log comes up
while [  ! -f $SAG_HOME/UniversalMessaging/server/$REALM/data/nirvana.log ]; do
    tail $SAG_HOME/UniversalMessaging/server/$REALM/bin/UMRealmService.log
    sleep 5
done

# Ensure that 'docker stop' performs a clean server shutdown
#export SERVER_PID=$(ps aux | grep nirvana | grep -v grep | awk '{print $2}')
#trap "rm $SAG_HOME/UniversalMessaging/server/$REALM/data/RealmServer.lck; wait $SERVER_PID" SIGTERM

# this is our main container process
echo "UM is ONLINE"
tail -f $SAG_HOME/UniversalMessaging/server/$REALM/data/nirvana.log