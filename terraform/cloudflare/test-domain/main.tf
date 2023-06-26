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

resource "cloudflare_record" "mx_domain_apex" {
  zone_id  = var.cloudflare_zone_id
  name     = "${var.domain_name}"
  type     = "MX"

  value    = "jgarfield.mail.protection.outlook.com"
  comment  = "Microsoft Exchange - Mail exchanger"
  priority = 0
  # tags     = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "microsoft-exchange",
  #   "mail-exchanger"
  # ])
}
