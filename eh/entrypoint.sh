#!/usr/bin/env bash

set -euo pipefail
set -x

wg-quick up /srv/wg0.conf
cat /etc/resolv.conf

curl ipinfo.io

# shellcheck disable=SC1091
source /etc/profile.d/jre.sh
java -jar HentaiAtHome.jar
