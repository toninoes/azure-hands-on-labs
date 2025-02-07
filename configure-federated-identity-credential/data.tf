data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_subscription" "this" {}

data "azuread_client_config" "this" {}
