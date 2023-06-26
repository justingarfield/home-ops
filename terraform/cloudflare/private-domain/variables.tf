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

variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone_id of the domain being configured"
  default     = ""
  sensitive = true
  validation {
    condition = length(var.cloudflare_zone_id) == 32
    error_message = "cloudflare_zone_id must be 32-characters in length"
  }
  validation {
    condition = length(regexall("[0-9a-fA-F]+", var.cloudflare_zone_id)) > 0
    error_message = "cloudflare_zone_id must contain hexidecimal characters only (e.g. 0123456789abcdef0123456789abcdef)"
  }
}

variable "domain_name" {
  type        = string
  description = "Used in any record that requires <your-domain>-<tld> as part of the record; keeping this value private."
  default     = ""
  validation {
    condition = length(var.domain_name) >= 4
    error_message = "domain_name must be at-least 4-characters in length (e.g. e.io)"
  }
  validation {
    condition = length(regexall("[.]", var.domain_name)) > 0
    error_message = "domain_name must contain at-least one period character (e.g. e.io)"
  }
}
