terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "5.6.0"
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
