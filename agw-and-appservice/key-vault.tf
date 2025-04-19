# Whizlabs no me permiten crear "User Assigned Managed Identity" necesario para que AGW acceda al KV
# resource "azurerm_key_vault" "this" {
#   name                = "toninoesKeyVault"
#   location            = data.azurerm_resource_group.this.location
#   resource_group_name = var.resource_group_name
#
#   sku_name  = "standard"
#   tenant_id = data.azurerm_client_config.this.tenant_id
#
#   access_policy {
#     tenant_id = data.azurerm_client_config.this.tenant_id
#     object_id = data.azurerm_client_config.this.object_id
#
#     certificate_permissions = ["Get", "List", "Update", "Import"]
#   }
# }
#
# resource "azurerm_key_vault_certificate" "this" {
#   name         = "toninoesEs"
#   key_vault_id = azurerm_key_vault.this.id
#
#   certificate {
#     contents = filebase64("${path.module}/cert/certificado.pfx")
#     password = trimspace(file("${path.module}/cert/pass.txt"))
#   }
# }