terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.62.0"
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
