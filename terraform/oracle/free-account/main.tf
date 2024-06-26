terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "5.47.0"
    }
  }

  backend "http" {
    update_method = "PUT"
  }
}

provider "oci" {
    tenancy_ocid = var.tenancy_ocid
    user_ocid = var.user_ocid
    fingerprint = var.fingerprint
    private_key_path = var.private_key_path
    region = var.region
}

resource "oci_identity_compartment" "home_ops" {
    compartment_id = var.root_compartment_ocid
    description = "Home Ops"
    name = "home-ops"
}

resource "oci_objectstorage_bucket" "home_ops_terraform_state" {
    compartment_id = oci_identity_compartment.home_ops.id
    namespace = var.object_storage_namespace
    name = "terraform-state"
}

resource "oci_budget_budget" "root_compartment_budget" {
    amount = 10
    compartment_id = var.root_compartment_ocid
    reset_period = "MONTHLY"
    description = "Account-wide budget"
    display_name = "Account-wide"
    target_type = "COMPARTMENT"
    targets = [ var.root_compartment_ocid ]
}

resource "oci_budget_alert_rule" "root_compartment_budget_alert_rule" {
    budget_id = oci_budget_budget.root_compartment_budget.id
    type = "FORECAST"
    message = "!! OCI Budget Alert - 80% Forecast Triggered !!"
    recipients = var.budget_alert_email_recipient
    threshold = 80
    threshold_type = "PERCENTAGE"
    display_name = "80-percent-budget-forecast"
    description = "Alerts when the Budget Forecast hits 80% or higher."
}

resource "oci_core_vcn" "home_ops" {
    compartment_id = oci_identity_compartment.home_ops.id

    cidr_block = "10.0.0.0/16"
    display_name = "Home Ops"
    dns_label = "homeops"
}

resource "oci_core_subnet" "home_ops" {
    cidr_block = "10.0.0.0/24"
    compartment_id = oci_identity_compartment.home_ops.id
    vcn_id = oci_core_vcn.home_ops.id

    display_name = "Home Ops Subnet"
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
    compartment_id = oci_identity_compartment.home_ops.id
    vcn_id = oci_core_vcn.home_ops.id

    enabled = true
    display_name = "Home Ops Internet Gateway"
}
