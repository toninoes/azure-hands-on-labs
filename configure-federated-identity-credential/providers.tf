provider "azurerm" {
  resource_provider_registrations = "none"

  features {}
}

provider "github" {
  token = var.github_token
  owner = "toninoes"
}
