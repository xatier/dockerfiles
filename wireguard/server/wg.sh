#!/usr/bin/bash

up() {
    set -x
    sudo wg-quick up wg/wg0.conf
    sudo wg
    set +x
}

down() {
    set -x
    sudo wg-quick down wg/wg0.conf
    set +x
}

keygen() {
    set -x
    wg genkey | tee privatekey | wg pubkey >publickey
    chmod 400 publickey privatekey
    set +x
    echo "public key: $(cat publickey)"
    echo "privatekey key: $(cat privatekey)"
}

if [ "$1" == "start" ]; then
    up
elif [ "$1" == "stop" ]; then
    down
elif [ "$1" == "keygen" ]; then
    keygen
else
    echo "[+] Usage: ./wg.sh start | stop | keygen"
fi
