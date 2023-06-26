variable "location" {
  type        = string
  description = "Azure region to target when deploying"
  default     = "East US 2"
}

variable "billingAccountId" {
  type        = string
  description = "The Id of the Azure Billing Account to place the Terraform provisioning Subscription under"
}

variable "billingProfileId" {
  type        = string
  description = "The Id of the Azure Billing Profile to place the Terraform provisioning Subscription under"
}

variable "invoiceSectionId" {
  type        = string
  description = "The Id of the Azure Billing Invoice Section to place the Terraform provisioning Subscription under"
}
