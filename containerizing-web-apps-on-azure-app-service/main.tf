resource "azurerm_container_registry" "this" {
  admin_enabled       = true
  location            = data.azurerm_resource_group.this.location
  name                = "helloworldwebapp"
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = local.tags
}

resource "azurerm_service_plan" "this" {
  location            = data.azurerm_resource_group.this.location
  name                = "hello-world-sp"
  os_type             = "Linux"
  resource_group_name = var.resource_group_name
  sku_name            = "B1"

  tags = local.tags
}

resource "azurerm_linux_web_app" "this" {
  https_only          = true
  location            = azurerm_service_plan.this.location
  name                = "hello-world-web-app"
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  site_config {
    always_on                               = true
    container_registry_use_managed_identity = true

    application_stack {
      docker_image_name        = "simple-html-app:latest"
      docker_registry_url      = "https://${azurerm_container_registry.this.login_server}"
      docker_registry_username = azurerm_container_registry.this.admin_username
      docker_registry_password = azurerm_container_registry.this.admin_password
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_role_assignment" "this" {
  principal_id         = azurerm_linux_web_app.this.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.this.id
}

module "gha_access_azure" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/github_actions_access_to_azure"

  app_display_name     = "azure-hands-on-labs"
  github_environment   = "sandbox"
  github_repository    = "azure-hands-on-labs"
  resource_group_name  = var.resource_group_name
  role_definition_name = "Contributor"

  github_extra_secrets = [
    {
      name  = "ACR_LOGIN_SERVER"
      value = azurerm_container_registry.this.login_server
    },
    {
      name  = "ACR_USERNAME"
      value = azurerm_container_registry.this.admin_username
    },
    {
      name  = "ACR_PASSWORD"
      value = azurerm_container_registry.this.admin_password
    },
    {
      name  = "AZURE_WEBAPP_NAME"
      value = azurerm_linux_web_app.this.name
    },
  ]
}