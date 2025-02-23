module "my_app" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/app_service_docker"

  app_name            = var.app_name
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

module "gha_access_azure" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/github_actions_access_to_azure"

  app_display_name     = var.app_name
  github_repository    = "azure-hands-on-labs"
  resource_group_name  = var.resource_group_name
  role_definition_name = "Contributor"

  depends_on = [module.my_app]
}
