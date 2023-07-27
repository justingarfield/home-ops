variable "tenancy_ocid" {
    type        = string
    description = "OCID of your tenancy."
    default     = ""
    sensitive = true
}

variable "user_ocid" {
    type        = string
    description = "OCID of the user calling the API."
    default     = ""
    sensitive = true
}

variable "fingerprint" {
    type        = string
    description = "Fingerprint for the key pair being used."
    default     = ""
    sensitive = true
}

variable "private_key_path" {
    type        = string
    description = "The path (including filename) of the private key stored on your computer."
    default     = ""
}

variable "region" {
    type        = string
    description = "An OCI region."
    default     = "us-ashburn-1"
}

variable "root_compartment_ocid" {
    type        = string
    description = "The root_compartment_ocid to be used by child compartments."
    default     = ""
    sensitive = true
}

variable "object_storage_namespace" {
    type        = string
    description = "The object_storage_namespace to be used by storage buckets."
    default     = ""
}

variable "budget_alert_email_recipient" {
    type        = string
    description = ""
    default     = ""
    sensitive = true
}
