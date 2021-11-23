# Setup wireguard on Debian 11 Bullseye on Azure VM

## Azure VM creation

```text
image: Debian 11 "Bullseye" - Gen2
size: Standard B1ls - 1 vcpu, 0.5 GiB memory (~$5/mo)
```

- find available Debian images

```bash
# az location to use
az account list-locations --output table

# find Debian offers
az vm image list-offers --location <location> --publisher Debian --output table
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
sudo apt install git tmux mosh htop curl
```

- install kernel headers and `resolvconf`

```bash
sudo apt install linux-headers-cloud-amd64 resolvconf
```

- restart `systemd-resolved` and ensure `/etc/resolv.conf` is configured
properly

```bash
sudo systemctl restart systemd-resolved
cat /etc/resolv.conf
```

- add hostname into `/etc/hosts`

```bash
vim /etc/hosts
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

- add `wireguard` into `/etc/modules-load.d/modules.conf`

```bash
sudo sh -c "echo 'wireguard' >> /etc/modules-load.d/modules.conf"
cat /etc/modules-load.d/modules.conf
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

- reboot the system to ensure everything is ready

```bash
sudo reboot
```

- pick a wireguard server port and add to the Azure VM networking rules

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

## IP management

Sometimes Azure public IPs may be acting weird, previous users of these
public IPs might have done some suspicious activities with them.

One can use the `new_ip.sh` script to allocate a new IP and switch to a new
one.

```bash
# update Azure resource group name and Azure region
vim ./new_ip.sh

./new_ip.sh
```

One the new IP has been created, navigate to **Azure Public IP Addresses
service**, select the newly created IP, then *Associate* it to a VM's
network interface.
