terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.55.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tenant-infrastructure"
    storage_account_name = "satenantinfrajpg"
    container_name       = "terraform-state-files"
    key                  = "terraform-azure-infrastructure.tfstate"
  }
}

locals {
  tags = {
    createdByProvisioner = ""
  }
}

provider "azurerm" {
  subscription_id = a

  features {}
}

##----- Resource Groups

resource "azurerm_resource_group" "tenant_infrastructure" {
  provider = azurerm.infrastructure
  name     = "rg-tenant-infrastructure"
  location = var.location
  tags     = local.tags
}


##----- Storage Accounts & Containers

resource "azurerm_storage_account" "tenant_provisioning" {
  name                     = "satenantinfrajpg"
  resource_group_name      = azurerm_resource_group.tenant_infrastructure.name
  location                 = azurerm_resource_group.tenant_infrastructure.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_storage_container" "state_files_container" {
  name                 = "terraform-state-files"
  storage_account_name = azurerm_storage_account.tenant_infrastructure.name
}


##----- Virtual Networks

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-hub-eastus2"
  location            = azurerm_resource_group.tenant_infrastructure.location
  resource_group_name = azurerm_resource_group.tenant_infrastructure.name
  address_space       = ["10.100.0.0/16"]
}
