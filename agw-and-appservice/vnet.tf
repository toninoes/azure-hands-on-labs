resource "azurerm_virtual_network" "this" {
  name                = "MiVNet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_subnet" "agw" {
  name                 = "agw-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
}

resource "azurerm_subnet" "pep" {
  name                 = "pep-subnet"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
}
