#!/bin/sh -eux

if [ -e "/etc/init.d/pcscd" ]; then
  echo "starting pcscd..."
  /etc/init.d/pcscd start
fi

echo "Start mirakc"
mirakc
