resource "azurerm_linux_virtual_machine" "this" {
  count = 2

  admin_username      = var.admin_username
  location            = data.azurerm_resource_group.this.location
  name                = "vm-${count.index}"
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.this[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.this.public_key_openssh
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

# SSH KEY-PAIRS
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pem" {
  filename        = "${var.ssh_key_pairs_name}.pem"
  content         = tls_private_key.this.private_key_pem
  file_permission = "0400"
}

resource "local_file" "pub" {
  filename        = "${var.ssh_key_pairs_name}.pub"
  content         = tls_private_key.this.public_key_openssh
  file_permission = "0400"
}

# NIC, PUBLIC-IP & NSG
resource "azurerm_network_interface" "this" {
  count = 2

  name                = "nic-${count.index}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nic-${count.index}-ip-configuration"
    subnet_id                     = azurerm_subnet.this[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this[count.index].id
  }

  tags = local.tags
}

resource "azurerm_public_ip" "this" {
  count = 2

  name                = "public-ip-${count.index}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = local.tags
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-vm"
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

resource "azurerm_network_interface_security_group_association" "this" {
  count = 2

  network_interface_id      = azurerm_network_interface.this[count.index].id
  network_security_group_id = azurerm_network_security_group.this.id
}
