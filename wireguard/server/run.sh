#!/usr/bin/env bash

set -ueo pipefail

AZURE_GROUP_NAME=""
AZURE_REGION=""

VM_NAME=""
VM_IMAGE="Debian:debian-12:12-gen2:latest"
VM_USERNAME=""

# the SSH public key stored in Azure
VM_SSH_PUBLIC_KEY=""

# the private key of the above RSA public key
VM_SSH_KEY_RSA=""

# the local ed25519 key to be uploaded to the new VM
VM_SSH_KEY_ED25519=""

WG_PORT=""

set -x

az vm create \
    --resource-group "$AZURE_GROUP_NAME" \
    --name "$VM_NAME" \
    --location "$AZURE_REGION" \
    --ssh-key-name "$VM_SSH_PUBLIC_KEY" \
    --admin-username "$VM_USERNAME" \
    --authentication-type ssh \
    --image "$VM_IMAGE" \
    --size Standard_B1ls \
    --storage-sku Standard_LRS \
    --public-ip-sku Standard

sleep 5

az vm boot-diagnostics enable \
    --resource-group "$AZURE_GROUP_NAME" \
    --name "$VM_NAME"

az vm open-port \
    --resource-group "$AZURE_GROUP_NAME" \
    --name "$VM_NAME" \
    --port "$WG_PORT" \
    --priority 1010 \
    --output table

# open port range for mosh
az vm open-port \
    --resource-group "$AZURE_GROUP_NAME" \
    --name "$VM_NAME" \
    --port 60000-61000 \
    --priority 1020 \
    --output table

sleep 10

IP="$(
    az vm list-ip-addresses \
        --resource-group "$AZURE_GROUP_NAME" \
        --name "$VM_NAME" \
        --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" \
        --output tsv
)"

# copy over the ed25519 key
ssh-keyscan -t ssh-ed25519 "$IP" >>"$HOME/.ssh/known_hosts"
ssh-copy-id -f -i "$VM_SSH_KEY_ED25519.pub" \
    -o "IdentityFile $VM_SSH_KEY_RSA" "$IP"

set +e
scp -i "$VM_SSH_KEY_ED25519" setup.sh "$IP:~/"
ssh -i "$VM_SSH_KEY_ED25519" -t "$IP" "chmod +x setup.sh && ./setup.sh $VM_NAME"
set -e
