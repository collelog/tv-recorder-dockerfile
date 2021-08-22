#!/bin/sh

if [ -e "/etc/init.d/pcscd" ]; then
  /etc/init.d/pcscd stop > /dev/null 2>&1 || echo "stoping pcscd..."
  sleep 2
  /etc/init.d/pcscd start > /dev/null 2>&1 || echo "starting pcscd..."
fi

echo "Start mirakc"
mirakc
