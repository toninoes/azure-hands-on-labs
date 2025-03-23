module "vnet_0" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/virtual-network"

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
  virtual_network_name = "vnet-0"
}

module "agw" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/application-gateway"

  name                = "myappgw"
  resource_group_name = var.resource_group_name
  frontend_ip_configuration_public_name = var.frontend_ip_configuration_public_name

  backend_address_pools = [
    {
      name = "my-backend-address-pool"
    }
  ]

  backend_http_settings_list = [
    {
      name                  = "my-backend-http-settings"
      cookie_based_affinity = "Disabled"
      path                  = "/path1/"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 60
    }
  ]

  frontend_ports = [
    {
      name = "my-frontend-port"
      port = 80
    }
  ]

  gateway_ip_configurations = [
    {
      name      = "my-gateway-ip-configuration"
      subnet_id = module.vnet_0.subnet["vnet-0-subnet-0"].id
    }
  ]

  http_listeners = [
    {
      name                           = "my-http-listener"
      frontend_ip_configuration_name = var.frontend_ip_configuration_public_name
      frontend_port_name             = "my-frontend-port"
      protocol                       = "Http"
    }
  ]

  request_routing_rules = [
    {
      name                       = "my-request-routing-rule"
      priority                   = 9
      rule_type                  = "Basic"
      http_listener_name         = "my-http-listener"
      backend_address_pool_name  = "my-backend-address-pool"
      backend_http_settings_name = "my-backend-http-settings"
    }
  ]

  depends_on = [module.vnet_0]
}
