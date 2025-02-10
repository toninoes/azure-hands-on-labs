output "AZURE_CLIENT_ID" {
  value = azuread_application.this.client_id
}

output "AZURE_SUBSCRIPTION_ID" {
  value = data.azurerm_client_config.this.subscription_id
}

output "AZURE_TENANT_ID" {
  value = data.azuread_client_config.this.tenant_id
}