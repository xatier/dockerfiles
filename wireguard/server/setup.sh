#!/usr/bin/env bash

VM_NAME="$1"

set -ueo pipefail
set -x

# proper TERM and bashrc setup
export TERM=xterm
{
    echo 'export TERM=xterm'
    echo 'export EDITOR=vim'
    echo "alias ta='tmux attach -d'"
} >>~/.bashrc

# disable mouse
{
    echo 'set mouse='
    echo 'set ttymouse='
} >>~/.vimrc

# full system update and install some helpful tools
sudo apt update
sudo apt upgrade -y
sudo apt install -y git tmux mosh htop curl dnsutils

# install kernel headers and systemd-resolved
sudo apt install -y linux-headers-cloud-amd64 systemd-resolved

# update DNS server and enable DNSOverTLS
sudo sed -i 's/^#DNS=$/DNS=1.1.1.1/' /etc/systemd/resolved.conf
sudo sed -i 's/^#DNSOverTLS=no$/DNSOverTLS=yes/' /etc/systemd/resolved.conf

# restart systemd-resolved and ensure /etc/resolv.conf is configured properly
sudo systemctl restart systemd-resolved
cat /etc/resolv.conf

# add hostname into /etc/hosts
sudo sed -i "/127\.0\.0\.1/ s/$/ $VM_NAME/" /etc/hosts
cat /etc/hosts

# install wireguard
sudo apt install -y wireguard

# ensure the wireguard kernel module is installed properly
sudo modprobe wireguard
lsmod | grep wireguard

# ensure wireguard kernel is loaded on boot
sudo sh -c "echo 'wireguard' >> /etc/modules-load.d/modules.conf"
cat /etc/modules-load.d/modules.conf

# enable forwarding
sudo sh -c "echo 'net.ipv4.ip_forward=1' > //etc/sysctl.d/10-forwarding.conf"
sudo sh -c "echo 'net.ipv6.conf.all.forwarding=1' >> //etc/sysctl.d/10-forwarding.conf"
grep forward /etc/sysctl.d/10-forwarding.conf

# update kernel parameters
sudo sysctl --system

# reboot!
sudo reboot
