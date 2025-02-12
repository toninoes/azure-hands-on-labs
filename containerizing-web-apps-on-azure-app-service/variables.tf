variable "app_name" {
  default = "toninoes"
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "resource_group_name" {
  description = "Resource group where to deploy."
  type        = string
}
