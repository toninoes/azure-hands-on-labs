variable "resource_group_name" {
  description = "Resource group where to deploy."
  type        = string
}

variable "frontend_ip_configuration_public_name" {
  default = "my-frontend-ip-configuration"
}