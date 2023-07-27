terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.10.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "terraform"
  #   storage_account_name = "jpg-home-ops-terraform"
  #   container_name       = "terraform-state-files"
  #   key                  = "cloudflare-zero-trust.tfstate"
  # }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_teams_location" "default_location" {
  account_id     = var.cloudflare_account_id
  name           = "Default Location"
  client_default = true

  networks {
    network = "${var.public_ip_address}/32"
  }
}
