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

- follow [this doc](https://docs.microsoft.com/en-us/azure/virtual-machines/ssh-keys-azure-cli) to add an RSA key on Azure.
- Azure VM currently only supports RSA keys, use the RSA key during creation.
- ED25519 key will be copied later.
- update the following variables in `run.sh`.

```text
AZURE_GROUP_NAME
AZURE_REGION

VM_NAME
VM_USERNAME
VM_SSH_PUBLIC_KEY
VM_SSH_PUBLIC_KEY_ED25519

WG_PORT
```

- `run.sh` will create the VM and setup wireguard configuration.

```bash
./run.sh
```

- `WG_PORT` and `mosh` ports (60000-61000) will be open.

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

- update config or script with remote editing over `scp`.

```bash
vimdiff wg.sh scp://<server>//home/<user>/wg.sh
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
