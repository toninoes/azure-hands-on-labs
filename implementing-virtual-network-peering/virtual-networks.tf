resource "azurerm_virtual_network" "this" {
  count = 2

  name                = "vnet-${count.index}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.${count.index}.0.0/16"]

  tags = local.tags
}

resource "azurerm_subnet" "this" {
  count = 2

  name                 = "subnet-${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[count.index].name
  address_prefixes     = ["10.${count.index}.0.0/24"]
}

# PEERING
resource "azurerm_virtual_network_peering" "vnet_0_to_vnet_1" {
  name                      = "peer-0-to-1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this[0].name
  remote_virtual_network_id = azurerm_virtual_network.this[1].id
}

resource "azurerm_virtual_network_peering" "vnet_1_to_vnet_0" {
  name                      = "peer-1-to-0"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this[1].name
  remote_virtual_network_id = azurerm_virtual_network.this[0].id
}