#!/bin/sh -eux

if [ -f "/opt/tvchannels-scan/scanner" ]; then
  chmod +x scanner
  ./scanner
else
  mv channels.yml channels.yml_`date +%Y%m%d-%H%M%S` 2>/dev/null || echo "backup channels.yml"
  mv channels_mirakc.yml channels_mirakc.yml_`date +%Y%m%d-%H%M%S` 2>/dev/null || echo "backup channels_mirakc.yml"
  scan_ch_mirak.sh
fi
