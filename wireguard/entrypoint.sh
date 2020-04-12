#!/usr/bin/env bash

set -euo pipefail
set -x

sudo wg-quick up /srv/wg0.conf
curl ipinfo.io

sleep 5

/usr/bin/sockd -f /srv/sockd.conf -p /dev/null
