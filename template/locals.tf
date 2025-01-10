locals {
  location = data.azurerm_resource_group.this.location

  tags = {
    CreatedBy   = "azure-hands-on-labs"
    Environment = "sandbox"
    Owner       = "toni"
  }
}
