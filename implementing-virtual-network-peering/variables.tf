variable "admin_username" {
  default     = "toninoes"
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
  type        = string
}

variable "public_key_location" {
  default = "~/.ssh/toninoes.pub"
  description = "The Public Key which should be used for authentication, which needs to be in ssh-rsa format with at least 2048-bit or in ssh-ed25519 format. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where to deploy."
  type        = string
}
