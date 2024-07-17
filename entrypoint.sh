#!/bin/sh

trap shutdown 0 15

shutdown()
{
  echo "Trapped Shutdown Signal"
  kill -TERM "${child}" 2>/dev/null
  /opt/webmethods/shutdown.sh
}

wait_term()
{
  wait ${child}
  trap - TERM INT
  wait ${child}
}

/opt/webmethods/startup.sh &
child=$!

wait_term