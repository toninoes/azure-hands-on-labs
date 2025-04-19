# Whizlabs no me permiten crear "User Assigned Managed Identity"
# resource "azurerm_user_assigned_identity" "this" {
#   name                = "Identidad-AGW"
#   location            = data.azurerm_resource_group.this.location
#   resource_group_name = var.resource_group_name
# }
#
# resource "azurerm_role_assignment" "this" {
#   scope                = azurerm_key_vault.this.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.this.principal_id
# }
