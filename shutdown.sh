#!/bin/sh

echo "Stopping webMethods components......"

echo "SPM......"
/opt/webmethods/profiles/SPM/bin/shutdown.sh

echo "Integration Server......"
/opt/webmethods/profiles/IS_default/bin/shutdown.sh

echo "my webMethods server......"
cd /opt/webmethods/MWS/server/default/bin
./shutdown.sh

echo "Universal Messaging......"
/opt/webmethods/UniversalMessaging/server/umserver/bin/nserverdaemon stop
