# VIRTUAL NETWORKS
resource "azurerm_virtual_network" "vnet_1" {
  name                = "vnet-1"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]

  tags = local.tags
}

resource "azurerm_subnet" "subnet_a" {
  name                 = "subnetA"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_1.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_virtual_network" "vnet_2" {
  name                = "vnet-2"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.2.0.0/16"]

  tags = local.tags
}

resource "azurerm_subnet" "subnet_b" {
  name                 = "subnetB"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_2.name
  address_prefixes     = ["10.2.0.0/24"]
}

# PEERINGS
resource "azurerm_virtual_network_peering" "vnet_1_to_vnet_2" {
  name                      = "peer-1-to-2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_2.id
}

resource "azurerm_virtual_network_peering" "vnet_2_to_vnet_1" {
  name                      = "peer-2-to-1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_1.id
}

# VIRTUAL MACHINES

# VM-1
resource "azurerm_linux_virtual_machine" "vm_1" {
  admin_username      = var.admin_username
  location            = data.azurerm_resource_group.this.location
  name                = "vm-1"
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.nic_1.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_location)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.tags
}

resource "azurerm_public_ip" "pub_ip_1" {
  name                = "public-ip-1"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = local.tags
}

resource "azurerm_network_interface" "nic_1" {
  name                = "nic-1"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nic-1-ip-configuration"
    subnet_id                     = azurerm_subnet.subnet_a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub_ip_1.id
  }

  tags = local.tags
}

resource "azurerm_network_security_group" "nsg_1" {
  name                = "nsg-1"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowExternalConnectionFromSpecificIP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.my_ip
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc_1" {
  network_interface_id      = azurerm_network_interface.nic_1.id
  network_security_group_id = azurerm_network_security_group.nsg_1.id
}

# VM-2
resource "azurerm_linux_virtual_machine" "vm_2" {
  admin_username      = var.admin_username
  location            = data.azurerm_resource_group.this.location
  name                = "vm-2"
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.nic_2.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_location)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.tags
}

resource "azurerm_public_ip" "pub_ip_2" {
  name                = "public-ip-2"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = local.tags
}

resource "azurerm_network_interface" "nic_2" {
  name                = "nic-2"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nic-2-ip-configuration"
    subnet_id                     = azurerm_subnet.subnet_b.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub_ip_2.id
  }

  tags = local.tags
}

resource "azurerm_network_security_group" "nsg_2" {
  name                = "nsg-2"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowExternalConnectionFromSpecificIP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.my_ip
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc_2" {
  network_interface_id      = azurerm_network_interface.nic_2.id
  network_security_group_id = azurerm_network_security_group.nsg_2.id
}
