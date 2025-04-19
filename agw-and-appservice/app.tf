resource "azurerm_service_plan" "this" {
  name                = "MiPlanApp"
  location            = data.azurerm_resource_group.this.location
  os_type             = "Linux"
  resource_group_name = var.resource_group_name
  sku_name            = "B1"
  tags                = local.tags
}

resource "azurerm_private_endpoint" "this" {
  name                = "MiPrivateEndpoint"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.pep.id
  tags                = local.tags

  private_service_connection {
    name                           = "MiPrivateConnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.this.id
    subresource_names              = ["sites"]
  }
}

resource "azurerm_linux_web_app" "this" {
  name                          = "toninoesdecady"
  location                      = data.azurerm_resource_group.this.location
  public_network_access_enabled = false
  resource_group_name           = var.resource_group_name
  service_plan_id               = azurerm_service_plan.this.id
  tags                          = local.tags

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
}
