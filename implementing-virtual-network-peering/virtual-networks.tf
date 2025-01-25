module "vnet_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_network"

  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.resource_group_name
  subnets = [
    {
      name    = "subnet-0"
      address = ["10.0.0.0/24"]
    },
    {
      name    = "subnet-1"
      address = ["10.0.1.0/24"]
    }
  ]
  tags                 = local.tags
  virtual_network_name = "vnet-0"
}

module "vnet_1" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_network"

  address_space       = ["10.1.0.0/16"]
  resource_group_name = var.resource_group_name
  subnets = [
    {
      name    = "subnet-0"
      address = ["10.1.0.0/24"]
    },
    {
      name    = "subnet-1"
      address = ["10.1.1.0/24"]
    }
  ]
  tags                 = local.tags
  virtual_network_name = "vnet-1"
}

# PEERING
resource "azurerm_virtual_network_peering" "vnet_0_to_vnet_1" {
  name                      = "peer-0-to-1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.vnet_0.name #azurerm_virtual_network.this[0].name
  remote_virtual_network_id = module.vnet_1.id   #azurerm_virtual_network.this[1].id
}

resource "azurerm_virtual_network_peering" "vnet_1_to_vnet_0" {
  name                      = "peer-1-to-0"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.vnet_1.name
  remote_virtual_network_id = module.vnet_0.id
}