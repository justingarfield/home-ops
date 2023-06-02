terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.59.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tenant-provisioning"
    storage_account_name = "satenantprovisioningjpg"
    container_name       = "terraform-state-files"
    key                  = "terraform-azure-provisioning.tfstate"
  }
}

locals {
  tags = {
    createdByProvisioner = ""
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_management_group" "tenant_root" {
  # name = "<root group uuid/name here if you don't want to use display_name>"
  display_name = var.tenantRootDisplayName
}

data "azurerm_billing_mca_account_scope" "billing" {
  billing_account_name = var.billingAccountId
  billing_profile_name = var.billingProfileId
  invoice_section_name = var.invoiceSectionId
}


##----- Management Groups

#:: /Tenant Root Group/mg-tenant-infrastructure
resource "azurerm_management_group" "tenant_infrastructure" {
  display_name               = "mg-tenant-infrastructure"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

#:: /Tenant Root Group/mg-labs
resource "azurerm_management_group" "labs" {
  display_name               = "mg-labs"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

#:: /Tenant Root Group/mg-other
resource "azurerm_management_group" "other" {
  display_name               = "mg-other"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}


##----- Subscriptions

#:: /Tenant Root Group/mg-infrastructure/tenant-infrastructure
resource "azurerm_subscription" "tenant_infrastructure" {
  alias             = "tenant-infrastructure"
  subscription_name = "tenant-infrastructure"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id
  tags              = local.tags
}

#:: /Tenant Root Group/mg-labs/labs
resource "azurerm_subscription" "labs" {
  alias             = "labs"
  subscription_name = "labs"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id
  tags              = local.tags
}

#:: /Tenant Root Group/mg-other/other
resource "azurerm_subscription" "other" {
  alias             = "other"
  subscription_name = "other"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing.id
  tags              = local.tags
}


##----- Subscription to Management Group Associations

resource "azurerm_management_group_subscription_association" "tenant_infrastructure" {
  management_group_id = azurerm_management_group.tenant_infrastructure.id
  subscription_id     = "/subscriptions/${resource.azurerm_subscription.tenant_infrastructure.subscription_id}"
}

resource "azurerm_management_group_subscription_association" "labs" {
  management_group_id = azurerm_management_group.labs.id
  subscription_id     = "/subscriptions/${resource.azurerm_subscription.labs.subscription_id}"
}

resource "azurerm_management_group_subscription_association" "other" {
  management_group_id = azurerm_management_group.other.id
  subscription_id     = "/subscriptions/${resource.azurerm_subscription.other.subscription_id}"
}


##----- Resource Groups

resource "azurerm_resource_group" "tenant_provisioning" {
  name     = "rg-tenant-provisioning"
  location = var.location
  tags     = local.tags
}


##----- Storage Accounts & Containers

resource "azurerm_storage_account" "tenant_provisioning" {
  name                     = "satenantprovisioningjpg"
  resource_group_name      = azurerm_resource_group.tenant_provisioning.name
  location                 = azurerm_resource_group.tenant_provisioning.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_storage_container" "state_files_container" {
  name                 = "terraform-state-files"
  storage_account_name = azurerm_storage_account.tenant_provisioning.name
}
