data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_network_interface" "this" {
  name                = azurerm_private_endpoint.this.network_interface[0].name
  resource_group_name = var.resource_group_name
}

data "azurerm_client_config" "this" {}
