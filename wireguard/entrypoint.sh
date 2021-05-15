#!/usr/bin/env bash

set -euo pipefail
set -x

sudo wg-quick up /srv/wg0.conf
cat /etc/resolv.conf

curl ipinfo.io

git clone https://github.com/xatier/toy-socks5.git
cd toy-socks5

go build
./toy-socks5 -global

# use python version
# python server.py

# use dante
# sleep 5
# /usr/bin/sockd -f /srv/sockd.conf -p /dev/null
bash
