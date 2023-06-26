terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "rg-tenant-provisioning"
  #   storage_account_name = "satenantprovisioningjpg"
  #   container_name       = "terraform-state-files"
  #   key                  = "terraform-azure-provisioning.tfstate"
  # }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  domain_key = replace(var.domain_name, ".", "-")
  onmicrosoft_domain_name = "powerislife"
}
