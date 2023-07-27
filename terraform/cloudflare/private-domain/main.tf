terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.10.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "jpg-home-ops-terraform"
    container_name       = "terraform-state-files"
    key                  = "cloudflare-private-domain.tfstate"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  domain_key = replace(var.domain_name, ".", "-")
}
