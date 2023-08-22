#!/usr/bin/env sh

# See: https://cert-manager.io/docs/configuration/acme/dns01/azuredns/#service-principal
#      https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure.md#service-principal

# Choose a name for the service principal that contacts Azure DNS to present the challenge.
AZURE_DNS_CONTRIB_SP_NAME=$1

# This is the name of the Resource Group that the DNS Zones are located in.
AZURE_DNS_ZONE_RESOURCE_GROUP=$2

# The Public and Private DNS zone names. They should be something like domain.com or sub.domain.com.
PUBLIC_DNS_ZONE=$3
PRIVATE_DNS_ZONE=$4

# Create the Service Principal and capture its important bits o' info
DNS_SP=$(az ad sp create-for-rbac --name $AZURE_DNS_CONTRIB_SP_NAME --output json)
AZURE_CERT_MANAGER_SP_APP_ID=$(echo $DNS_SP | yq -r '.appId')
AZURE_CERT_MANAGER_SP_PASSWORD=$(echo $DNS_SP | yq -r '.password')
AZURE_TENANT_ID=$(echo $DNS_SP | yq -r '.tenant')
AZURE_SUBSCRIPTION_ID=$(az account show --output json | yq -r '.id')

# Assign the DNS Zone Contributor to the Service Principal, and set its scope way down at the Public DNS Zone resource itself.
PUBLIC_DNS_ID=$(az network dns zone show --name $PUBLIC_DNS_ZONE --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP --query "id" --output tsv)
az role assignment create --assignee $AZURE_CERT_MANAGER_SP_APP_ID --role "DNS Zone Contributor" --scope $PUBLIC_DNS_ID

# Assign the DNS Zone Contributor to the Service Principal, and set its scope way down at the Private DNS Zone resource itself.
PRIVATE_DNS_ID=$(az network dns zone show --name $PRIVATE_DNS_ZONE --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP --query "id" --output tsv)
az role assignment create --assignee $AZURE_CERT_MANAGER_SP_APP_ID --role "DNS Zone Contributor" --scope $PRIVATE_DNS_ID

# Output all of the pertinent information used to configure Secrets, ConfigMaps, and what-not.
echo "AZURE_CERT_MANAGER_SP_APP_ID: $AZURE_CERT_MANAGER_SP_APP_ID"
echo "AZURE_CERT_MANAGER_SP_PASSWORD: $AZURE_CERT_MANAGER_SP_PASSWORD"
echo "AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
echo "AZURE_TENANT_ID: $AZURE_TENANT_ID"
echo "PUBLIC_DNS_ZONE: $PUBLIC_DNS_ZONE"
echo "PRIVATE_DNS_ZONE: $PRIVATE_DNS_ZONE"
echo "AZURE_DNS_ZONE_RESOURCE_GROUP: $AZURE_DNS_ZONE_RESOURCE_GROUP"
