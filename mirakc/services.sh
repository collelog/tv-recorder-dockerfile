#!/bin/sh -eux

if [ -e "/etc/init.d/pcscd" ]; then
  echo "stopping pcscd..."
  /etc/init.d/pcscd stop
  sleep 2
  echo "starting pcscd..."
  /etc/init.d/pcscd start
fi

echo "Start mirakc"
mirakc
