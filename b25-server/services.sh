#!/bin/sh -eux

mkdir -p /var/run/pcscd
rm -rf /var/run/pcscd

echo "Start pcscd"
pcscd -f -e &

echo "Start a pcscd proxy on tcp 40774"
socat tcp-listen:40774,fork,reuseaddr unix-connect:/var/run/pcscd/pcscd.comm &

echo "Start a b25 server on tcp 40773"
socat tcp-listen:40773,fork,reuseaddr system:arib-b25-stream-test
