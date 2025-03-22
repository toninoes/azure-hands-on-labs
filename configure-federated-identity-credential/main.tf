module "gha_access_azure" {
  source = "git::git@github.com:toninoes/modulodromo.git//azure/github-actions-access-to-azure"

  app_display_name     = "azure-hands-on-labs"
  github_environment   = "sandbox"
  github_repository    = "azure-hands-on-labs"
  resource_group_name  = var.resource_group_name
  role_definition_name = "Contributor"
}
