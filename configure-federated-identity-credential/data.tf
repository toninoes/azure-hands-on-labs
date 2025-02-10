data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azuread_client_config" "this" {}

data "azurerm_client_config" "this" {}
