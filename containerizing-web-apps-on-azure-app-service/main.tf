module "my_app" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/app_service_containerized"

  app_name            = var.app_name
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

module "gha_access_azure" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/github_actions_access_to_azure"

  app_display_name     = var.app_name
  github_environment   = "sandbox"
  github_repository    = "azure-hands-on-labs"
  resource_group_name  = var.resource_group_name
  role_definition_name = "Contributor"

  github_extra_secrets = [
    {
      name  = "ACR_LOGIN_SERVER"
      value = module.my_app.container_registry_login_server
    },
    {
      name  = "ACR_USERNAME"
      value = module.my_app.container_registry_admin_username
    },
    {
      name  = "ACR_PASSWORD"
      value = module.my_app.container_registry_admin_password
    },
    {
      name  = "AZURE_WEBAPP_NAME"
      value = module.my_app.web_app_name
    },
    {
      name  = "ACR_CONTAINER_NAME"
      value = module.my_app.container_registry_name
    },
  ]

  depends_on = [module.my_app]
}
