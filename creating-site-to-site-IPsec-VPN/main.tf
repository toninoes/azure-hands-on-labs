module "vnet_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_network"

  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.resource_group_name
  subnets = [
    {
      name    = "subnet-0"
      address = ["10.0.0.0/24"]
    }
  ]
  subnet_addresses_for_vpn_gateway = ["10.0.2.0/26"]
  tags                             = local.tags
  virtual_network_name             = "vnet-0"
}

module "onprem" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_network"

  address_space       = ["10.1.0.0/16"]
  resource_group_name = var.resource_group_name
  subnets = [
    {
      name    = "subnet-0"
      address = ["10.1.0.0/24"]
    }
  ]
  subnet_addresses_for_vpn_gateway = ["10.1.2.0/26"]
  tags                             = local.tags
  virtual_network_name             = "onprem"
}

resource "azurerm_local_network_gateway" "vnet_0" {
  name                = "vnet-0"
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.this.location
  gateway_address     = module.vnet_0.public_ip_vpn_gateway
  address_space       = module.vnet_0.address_space

  depends_on = [module.vnet_0]
}

resource "azurerm_local_network_gateway" "onprem" {
  name                = "onprem"
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.this.location
  gateway_address     = module.onprem.public_ip_vpn_gateway
  address_space       = module.onprem.address_space

  depends_on = [module.onprem]
}

resource "azurerm_virtual_network_gateway_connection" "vpn_tunnel_vnet_0_to_onprem" {
  name                = "vpn-tunnel-vnet-0-to-onprem"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = module.vnet_0.virtual_network_gateway_id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem.id

  shared_key = "key1234!"

  ipsec_policy {
    dh_group         = "DHGroup1"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS1"
    sa_datasize      = 1024
    sa_lifetime      = 86400
  }

  depends_on = [module.vnet_0]
}

resource "azurerm_virtual_network_gateway_connection" "vpn_tunnel_onprem_to_vnet_0_" {
  name                = "vpn-tunnel-onprem-to-vnet-0"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = module.onprem.virtual_network_gateway_id
  local_network_gateway_id   = azurerm_local_network_gateway.vnet_0.id

  shared_key = "key1234!"

  ipsec_policy {
    dh_group         = "DHGroup1"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS1"
    sa_datasize      = 1024
    sa_lifetime      = 86400
  }

  depends_on = [module.onprem]
}

# Virtual Machines
module "vm_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_machine"

  admin_username       = var.admin_username
  name                 = "vm-0"
  resource_group_name  = var.resource_group_name
  subnet_name          = "vnet-0-subnet-0"
  ssh_key_pairs_name   = "${var.ssh_key_pairs_name}-vnet-0"
  virtual_network_name = module.vnet_0.name

  depends_on = [module.vnet_0]
}

module "vm_onprem" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_machine"

  admin_username       = var.admin_username
  name                 = "vm-onprem"
  resource_group_name  = var.resource_group_name
  subnet_name          = "onprem-subnet-0"
  ssh_key_pairs_name   = "${var.ssh_key_pairs_name}-onprem"
  virtual_network_name = module.onprem.name

  depends_on = [module.onprem]
}