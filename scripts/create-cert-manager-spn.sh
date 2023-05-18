#!/bin/sh

# See: https://cert-manager.io/docs/configuration/acme/dns01/azuredns/#service-principal

# Choose a name for the service principal that contacts azure DNS to present
# the challenge.
AZURE_CERT_MANAGER_NEW_SP_NAME=$1

# This is the name of the resource group that you have your dns zone in.
AZURE_DNS_ZONE_RESOURCE_GROUP=$2

# The DNS zone name. It should be something like domain.com or sub.domain.com.
PUBLIC_DNS_ZONE=$3
PRIVATE_DNS_ZONE=$4

DNS_SP=$(az ad sp create-for-rbac --name $AZURE_CERT_MANAGER_NEW_SP_NAME --output json)
AZURE_CERT_MANAGER_SP_APP_ID=$(echo $DNS_SP | yq -r '.appId')
AZURE_CERT_MANAGER_SP_PASSWORD=$(echo $DNS_SP | yq -r '.password')
AZURE_TENANT_ID=$(echo $DNS_SP | yq -r '.tenant')
AZURE_SUBSCRIPTION_ID=$(az account show --output json | yq -r '.id')

# az role assignment delete --assignee $AZURE_CERT_MANAGER_SP_APP_ID --role Contributor

PUBLIC_DNS_ID=$(az network dns zone show --name $PUBLIC_DNS_ZONE --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP --query "id" --output tsv)
az role assignment create --assignee $AZURE_CERT_MANAGER_SP_APP_ID --role "DNS Zone Contributor" --scope $PUBLIC_DNS_ID

PRIVATE_DNS_ID=$(az network dns zone show --name $PRIVATE_DNS_ZONE --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP --query "id" --output tsv)
az role assignment create --assignee $AZURE_CERT_MANAGER_SP_APP_ID --role "DNS Zone Contributor" --scope $PRIVATE_DNS_ID

# az role assignment list --all --assignee $AZURE_CERT_MANAGER_SP_APP_ID

echo "AZURE_CERT_MANAGER_SP_APP_ID: $AZURE_CERT_MANAGER_SP_APP_ID"
echo "AZURE_CERT_MANAGER_SP_PASSWORD: $AZURE_CERT_MANAGER_SP_PASSWORD"
echo "AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
echo "AZURE_TENANT_ID: $AZURE_TENANT_ID"
echo "PUBLIC_DNS_ZONE: $PUBLIC_DNS_ZONE"
echo "PRIVATE_DNS_ZONE: $PRIVATE_DNS_ZONE"
echo "AZURE_DNS_ZONE_RESOURCE_GROUP: $AZURE_DNS_ZONE_RESOURCE_GROUP"
