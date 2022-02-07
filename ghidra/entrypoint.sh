#!/usr/bin/env bash

set -euo pipefail
set -x

export JAVA_HOME=/usr/lib/jvm/default
export USER_HOME=/home/xatier
source /etc/profile.d/jre.sh

mkdir -p .ghidra/.ghidra_10.1.2_DEV/
cat <<EOF | tee .ghidra/.ghidra_10.1.2_DEV/preferences
#User Preferences
#Mon Feb 01 00:00:00 GMT 2022
USER_AGREEMENT=ACCEPT
SHOW_TIPS=false
ViewedProjects=
SHOW.HELP.NAVIGATION.AID=true
GhidraShowWhatsNew=false
RecentProjects=
TIP_INDEX=1
EOF

ghidra &
bash

