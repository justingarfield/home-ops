terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.62.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "terraform"
  #   storage_account_name = "jpg-home-ops-terraform"
  #   container_name       = "terraform-state-files"
  #   key                  = "azure-terraform-state.tfstate"
  # }
}


##----- Resource Groups

resource "azurerm_resource_group" "terraform" {
  name     = "terraform"
  location = var.location
}


##----- Storage Accounts & Containers

resource "azurerm_storage_account" "jpg_home_ops_terraform" {
  name                     = "jpg-home-ops-terraform"
  resource_group_name      = azurerm_resource_group.terraform.name
  location                 = azurerm_resource_group.terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "state_files_container" {
  name                 = "terraform-state-files"
  storage_account_name = azurerm_storage_account.jpg_home_ops_terraform.name
}
