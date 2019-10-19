#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract arguments from the input into shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "RG=\(.rg) VMSS=\(.vmss)"')"

# Login first
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID --output none

# Get private ip
IP=$(az vmss nic list --resource-group $RG --vmss-name $VMSS --query "[0].ipConfigurations[0].privateIpAddress" -o tsv)

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg ip "$IP" '{"ip":$ip}'