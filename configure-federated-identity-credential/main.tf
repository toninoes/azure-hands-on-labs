resource "azuread_application_registration" "this" {
  display_name     = "toninoes"
  #owners           = [data.azuread_client_config.this.object_id]
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application_registration.this.client_id
  owners    = [data.azuread_client_config.this.object_id]
}

resource "azurerm_role_assignment" "this" {
  principal_id         = azuread_service_principal.this.object_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_resource_group.this.id
}

resource "azuread_application_federated_identity_credential" "github_oidc" {
  application_id = azuread_application_registration.this.id
  display_name   = "GitHub-OIDC"
  description    = "Deployments for my-repo"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:toninoes/azure-hands-on-labs:ref:refs/heads/*"
  audiences      = ["api://AzureADTokenExchange"]
}