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

resource "azurerm_service_plan" "this" {
  name                = "MiPlanApp"
  location            = data.azurerm_resource_group.this.location
  os_type             = "Linux"
  resource_group_name = var.resource_group_name
  sku_name            = "S1"
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

resource "azurerm_public_ip" "this" {
  name                = "MiPublicIP"
  allocation_method   = "Static"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

data "azurerm_network_interface" "this" {
  name                = azurerm_private_endpoint.this.network_interface[0].name
  resource_group_name = var.resource_group_name
}

resource "azurerm_application_gateway" "this" {
  name                = "MiAppGateway"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  sku {
    name     = "Standard_v2"
    capacity = 2
    tier     = "Standard_v2"
  }

  frontend_port {
    name = "HttpPort"
    port = 80
  }

  gateway_ip_configuration {
    name      = "MiGatewayIPConfig"
    subnet_id = azurerm_subnet.agw.id
  }

  frontend_ip_configuration {
    name                 = "MiFrontendIP"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name         = "MiBackendPool"
    ip_addresses = [data.azurerm_network_interface.this.private_ip_address]
  }

  backend_http_settings {
    name                  = "MiHttpSettings"
    cookie_based_affinity = "Disabled"
    host_name             = azurerm_linux_web_app.this.default_hostname
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "MiHttpListener"
    frontend_ip_configuration_name = "MiFrontendIP"
    frontend_port_name             = "HttpPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "MiRequestRoutingRule"
    backend_address_pool_name  = "MiBackendPool"
    backend_http_settings_name = "MiHttpSettings"
    http_listener_name         = "MiHttpListener"
    priority                   = 1
    rule_type                  = "Basic"
  }
}
