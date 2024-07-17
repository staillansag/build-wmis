#!/bin/sh

find /opt/webmethods -type f -name '.lock' -exec rm {} \;

. /opt/webmethods/licenses.sh

echo "SPM......"
/opt/webmethods/profiles/SPM/bin/startup.sh

echo "Universal Messaging......"
/opt/webmethods/UniversalMessaging/server/umserver/bin/nserverdaemon start

echo "Integration Server......"
/opt/webmethods/profiles/IS_default/bin/startup.sh

echo "my webmethods server......"
cd /opt/webmethods/MWS/server/default/bin
./startup.sh

elapsed_time=0

while [ ! -f "/opt/webmethods/IntegrationServer/instances/default/logs/server.log" ] && [ $elapsed_time -lt 60 ]; do
    echo "Waiting for IS log file to be created..."
    sleep 1
    elapsed_time=$((elapsed_time + 1))
done

if [ -f "/opt/webmethods/IntegrationServer/instances/default/logs/server.log" ]; then
    tail -f /opt/webmethods/IntegrationServer/instances/default/logs/server.log
else
    echo "Timeout: File tail -f /opt/webmethods/IntegrationServer/instances/default/logs/server.log was not created within 60 seconds."
    exit 1
fi


