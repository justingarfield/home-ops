variable "cloudflare_api_token" {
  type        = string
  description = "The cloudflare_api_token used to access the zone and records being configured"
  default     = ""
  sensitive = true
  validation {
    condition = length(var.cloudflare_api_token) == 40
    error_message = "cloudflare_api_token must be 40-characters in length"
  }
}

variable "cloudflare_account_id" {
  type        = string
  description = "The Cloudflare account_id of the zero-trust settings being configured"
  default     = ""
  sensitive = true
  validation {
    condition = length(var.cloudflare_account_id) == 32
    error_message = "cloudflare_account_id must be 32-characters in length"
  }
  validation {
    condition = length(regexall("[0-9a-fA-F]+", var.cloudflare_account_id)) > 0
    error_message = "cloudflare_account_id must contain hexidecimal characters only (e.g. 0123456789abcdef0123456789abcdef)"
  }
}

variable "public_ip_address" {
  type        = string
  description = "Home conection public IP address"
  default     = ""
  sensitive = true
  validation {
    condition = length(var.public_ip_address) >= 7 && length(var.public_ip_address) <= 15
    error_message = "public_ip_address must be 7 to 15 characters in length (currently: ${length(var.public_ip_address)})"
  }
  validation {
    condition = length(regexall("[0-9.]+", var.public_ip_address)) > 0
    error_message = "public_ip_address must contain numeric and . characters only (e.g. 0123456789.)"
  }
}
