variable "admin_username" {
  default     = "toninoes"
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where to deploy."
  type        = string
}

variable "ssh_key_pairs_name" {
  default     = "toninoes"
  description = "Name used to create SSH key pairs."
  type        = string
}
