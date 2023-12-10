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

# full system update and install some helpful tools
sudo apt update
sudo apt upgrade -y
sudo apt install -y git tmux mosh htop curl dnsutils

# install kernel headers and systemd-resolved
sudo apt install -y linux-headers-cloud-amd64 systemd-resolved

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
sudo sed -i "/net.ipv4.ip_forward=1/ s/^#\(.*\)/\1/" /etc/sysctl.conf
sudo sed -i "/net.ipv6.conf.all.forwarding=1/ s/^#\(.*\)/\1/" /etc/sysctl.conf
grep forward /etc/sysctl.conf

# update kernel parameters
sudo sysctl --system

# reboot!
sudo reboot
