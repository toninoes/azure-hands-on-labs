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
    name = "HttpsPort"
    port = 443
  }

  # Whizlabs no me permiten crear "User Assigned Managed Identity"
  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.this.id]
  # }

  ssl_certificate {
    name                = "toninoesEs"
    #key_vault_secret_id = azurerm_key_vault_certificate.this.secret_id
    # No lo puedo hacer con el key-vault porque los sandbox de Whizlabs no me permiten crear "User Assigned Managed Identity"
    data     = filebase64("${path.module}/cert/certificado.pfx")
    password = trimspace(file("${path.module}/cert/pass.txt"))
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
    name                           = "MiHttpsListener"
    frontend_ip_configuration_name = "MiFrontendIP"
    frontend_port_name             = "HttpsPort"
    ssl_certificate_name           = "toninoesEs"
    protocol                       = "Https"
  }

  request_routing_rule {
    name                       = "MiRequestRoutingRule"
    backend_address_pool_name  = "MiBackendPool"
    backend_http_settings_name = "MiHttpSettings"
    http_listener_name         = "MiHttpsListener"
    priority                   = 1
    rule_type                  = "Basic"
  }
}
