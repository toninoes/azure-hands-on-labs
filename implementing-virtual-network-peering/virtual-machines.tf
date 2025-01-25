module "vm_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_machine"

  admin_username       = var.admin_username
  name                 = "vm-0"
  resource_group_name  = var.resource_group_name
  subnet_name          = "vnet-0-subnet-0"
  ssh_key_pairs_name   = "${var.ssh_key_pairs_name}-0"
  virtual_network_name = module.vnet_0.name

  depends_on = [module.vnet_0]
}

module "vm_1" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual_machine"

  admin_username       = var.admin_username
  name                 = "vm-1"
  resource_group_name  = var.resource_group_name
  subnet_name          = "vnet-1-subnet-0"
  ssh_key_pairs_name   = "${var.ssh_key_pairs_name}-1"
  virtual_network_name = module.vnet_1.name

  depends_on = [module.vnet_1]
}
