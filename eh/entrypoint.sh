#!/usr/bin/env bash

set -euo pipefail
set -x

wg-quick up /srv/wg0.conf
cat /etc/resolv.conf

curl ipinfo.io

# shellcheck disable=SC1091
sudo archlinux-java set java-17-openjdk
archlinux-java status

java -jar HentaiAtHome.jar
