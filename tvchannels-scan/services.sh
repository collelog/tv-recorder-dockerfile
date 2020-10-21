#!/bin/sh -eux

if [ -f "/opt/tvchannels-scan/scanner" ]; then
  chmod +x scanner
  ./scanner
else
  scan_ch_mirak.sh
fi
