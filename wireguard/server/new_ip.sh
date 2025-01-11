#!/usr/bin/env bash

# this script creates new IP on Azure,
# once the new public IP has been created,
# dissociate the old public IP from the Network interface card,
# then associate the public IP with the VMs in Azure Portal

set -ueo pipefail

# find Azure regions: az account list-locations --output table
AZURE_GROUP_NAME=""
AZURE_REGION=""

name="$AZURE_REGION-public-ip-$((1 + RANDOM % 1000))"

set -x
az network public-ip create \
    --resource-group "$AZURE_GROUP_NAME" \
    --location "$AZURE_REGION" \
    --name "$name" \
    --allocation-method Dynamic \
    --sku Standard \
    --version IPv4 \
    --tier Regional

sleep 5.0

az network public-ip list --resource-group "$AZURE_GROUP_NAME" --output table
