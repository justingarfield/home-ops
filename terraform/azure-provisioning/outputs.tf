output "tenant_infrastructure_subscription_id" {
  value       = azurerm_subscription.tenant_infrastructure.subscription_id
  description = "Tenant Infrastructure - Subscription Id"
}

output "labs_subscription_id" {
  value       = azurerm_subscription.labs.subscription_id
  description = "Labs - Subscription Id"
}

output "other_subscription_id" {
  value       = azurerm_subscription.other.subscription_id
  description = "Other - Subscription Id"
}
