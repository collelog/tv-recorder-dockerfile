#!/bin/sh -eux

rm -rf /var/run/pcscd
mkdir -p /var/run/pcscd

echo "Start pcscd"
pcscd -f -e
