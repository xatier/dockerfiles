#!/usr/bin/env bash

# reference: https://github.com/WorksApplications/Sudachi/blob/develop/docs/tutorial.md

set -euxo pipefail

sudo pacman -Syuu --noconfirm --needed jre-openjdk-headless unzip

# https://github.com/WorksApplications/Sudachi/releases/
wget -q https://github.com/WorksApplications/Sudachi/releases/download/v0.7.5/sudachi-0.7.5-executable.zip

# http://sudachi.s3-website-ap-northeast-1.amazonaws.com/sudachidict/
wget -q http://sudachi.s3-website-ap-northeast-1.amazonaws.com/sudachidict/sudachi-dictionary-20250129-full.zip

unzip sudachi-0.7.5-executable.zip
unzip sudachi-dictionary-20250129-full.zip

sudo archlinux-java set java-23-openjdk
archlinux-java status
