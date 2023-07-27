output "default_location__anonymized_logs_enabled" {
  value       = cloudflare_teams_location.default_location.anonymized_logs_enabled
  description = "Indicator that anonymized logs are enabled."
}

output "default_location__doh_subdomain" {
  value       = cloudflare_teams_location.default_location.doh_subdomain
  description = "The FQDN that DoH clients should be pointed at."
}

output "default_location__id" {
  value       = cloudflare_teams_location.default_location.id
  description = "The ID of this resource."
}

output "default_location__ip" {
  value       = cloudflare_teams_location.default_location.ip
  description = "Client IP address."
}

output "default_location__ipv4_destination" {
  value       = cloudflare_teams_location.default_location.ipv4_destination
  description = "IP to direct all IPv4 DNS queries to."
}
