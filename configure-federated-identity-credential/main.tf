resource "azuread_application" "this" {
  display_name     = "toninoes"
  owners           = [data.azuread_client_config.this.object_id]
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
  owners    = [data.azuread_client_config.this.object_id]
}

resource "azurerm_role_assignment" "this" {
  principal_id         = azuread_service_principal.this.object_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_resource_group.this.id
}

resource "azuread_application_federated_identity_credential" "github_oidc" {
  application_id = azuread_application.this.id
  display_name   = "GitHub-OIDC"
  description    = "Deployments for my-repo"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:toninoes/azure-hands-on-labs:environment:sandbox"
  audiences      = ["api://AzureADTokenExchange"]
}

resource "github_actions_environment_secret" "azure_client_id" {
  repository      = "azure-hands-on-labs"
  environment     = "sandbox"
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application.this.client_id
}

resource "github_actions_environment_secret" "azure_subscription_id" {
  repository      = "azure-hands-on-labs"
  environment     = "sandbox"
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_client_config.this.subscription_id
}

resource "github_actions_environment_secret" "azure_tenant_id" {
  repository      = "azure-hands-on-labs"
  environment     = "sandbox"
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azuread_client_config.this.tenant_id
}
