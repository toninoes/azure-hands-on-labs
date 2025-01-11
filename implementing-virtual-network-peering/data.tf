data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "external" "myipaddr" {
    program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}
