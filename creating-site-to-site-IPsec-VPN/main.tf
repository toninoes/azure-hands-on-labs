module "vnet_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual-network"

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
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual-network"

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

# VGW connections
module "vpn_tunnel_vnet_0_to_onprem" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/site-to-site-ipsec-vpn"

  address_space              = module.onprem.address_space
  gateway_address            = module.onprem.public_ip_vpn_gateway
  peer_name                  = "on-prem"

  resource_group_name        = var.resource_group_name
  shared_key                 = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  virtual_network_gateway_id = module.vnet_0.virtual_network_gateway_id
  vnet_gw_conn_name          = "vpn-tunnel-vnet-0-to-onprem"

  depends_on = [module.vnet_0, module.onprem]
}

module "vpn_tunnel_onprem_to_vnet_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/site-to-site-ipsec-vpn"

  address_space              = module.vnet_0.address_space
  gateway_address            = module.vnet_0.public_ip_vpn_gateway
  peer_name                  = "vnet-0"

  resource_group_name        = var.resource_group_name
  shared_key                 = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  virtual_network_gateway_id = module.onprem.virtual_network_gateway_id
  vnet_gw_conn_name          = "vpn-tunnel-onprem-to-vnet-0"

  depends_on = [module.vnet_0, module.onprem]
}

# Virtual Machines
module "vm_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual-machine"

  admin_username       = var.admin_username
  name                 = "vm-0"
  resource_group_name  = var.resource_group_name
  subnet_name          = "vnet-0-subnet-0"
  ssh_key_pairs_name   = "${var.ssh_key_pairs_name}-vnet-0"
  virtual_network_name = module.vnet_0.name

  depends_on = [module.vnet_0]
}

module "vm_onprem" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual-machine"

  admin_username       = var.admin_username
  name                 = "vm-onprem"
  resource_group_name  = var.resource_group_name
  subnet_name          = "onprem-subnet-0"
  ssh_key_pairs_name   = "${var.ssh_key_pairs_name}-onprem"
  virtual_network_name = module.onprem.name

  depends_on = [module.onprem]
}
