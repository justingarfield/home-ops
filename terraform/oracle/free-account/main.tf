terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "5.5.0"
    }
  }

  # backend "http" {
  #   address = "https://id9oxdiaaper.objectstorage.us-ashburn-1.oci.customer-oci.com/p/PrDmU0daYQ0D5Am_GJA82nwTJaHcBUwcQQ5tRetZDc6pGchzVgij06Buj8XtuiI8/n/id9oxdiaaper/b/home-ops/o/terraform.tfstate"
  #   update_method = "PUT"
  # }
  backend "s3" {
    bucket   = "terraform-state"
    key      = "free-account/terraform.tfstate"
    region   = "us-ashburn-1"
    endpoint = "https://id9oxdiaaper.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    shared_credentials_file     = "./terraform-bucket-credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
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
