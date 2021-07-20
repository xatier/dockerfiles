# Setup wireguard on Debian 10 Buster on Azure VM

## Azure VM creation

```text
image: Debian 10 "Buster" - Gen1
size: Standard B1ls - 1 vcpu, 0.5 GiB memory (~$5/mo)
```

- Azure VM currently only supports RSA keys, use the RSA key during creation.
- copy over my own ED25519 key later

```bash
ssh <server IP> -i ~/.ssh/azure_rsa
ssh-copy-id -i .ssh/azure_ed25519.pub <server domain>
```

- set `TERM` shell variable

```bash
export TERM=xterm
```

## Install wireguard

- update the system and install some helpful tools

```bash
sudo apt update
sudo apt upgrade
sudo apt install git tmux mosh glances htop curl
```

- install kernel headers and `resolvconf`

```bash
sudo apt install linux-headers-cloud-amd64 resolvconf
```

- add Debian 10 buster backports apt source

```bash
sudo sh -c "echo 'deb http://deb.debian.org/debian buster-backports main contrib non-free' > /etc/apt/sources.list.d/buster-backports.list"
cat /etc/apt/sources.list.d/buster-backports.list
sudo apt update
```

- install wireguard

```bash
sudo apt install wireguard
```

- make sure the wireguard kernel module is installed properly

```bash
sudo modprobe wireguard
lsmod | grep wireguard
```

- uncomment or add the following in `/etc/sysctl.conf` to allow forwarding

```bash
sudo vim /etc/sysctl.conf
```

```text
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
```

- update kernel parameters

```bash
sudo sysctl --system
```

- pick a wireguard server port and add to the networking rules

```text
Source: Any
Source port ranges: *
Destination: Any
Service: Custom
Destination port ranges: <server port>
Protocol: Any
Action: Allow
Priority: 10xx
```

## Configure wireguard

- clone this repo for the config template

```bash
git clone https://github.com/xatier/dockerfiles.git

# move things under home
mv dockerfiles/wireguard/server/wg .
mv dockerfiles/wireguard/server/wg.sh .

cd wg
```

- generate server key pairs

```bash
~/wg.sh keygen

# add the server key pairs to wg0.conf
vim wg0.conf
```

- generate client key pairs

```bash
mkdir client1
cd client1
~/wg.sh keygen
cd ..

# add the client key pairs to wg0.conf
vim wg0.conf
```

- add the client key pairs to client's wg0.conf

- start the server

```bash
cd ~/
~/wg.sh start
```
