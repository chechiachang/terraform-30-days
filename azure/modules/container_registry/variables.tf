variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

#variable "environment" {
#  type = string
#}

# Registry

variable "registry_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Basic"
}

variable "admin_enabled" {
  type    = bool
  default = false
}

variable "public_network_access_enabled" {
  type    = bool
  default = false
}

variable "georeplications" {
  type = map(object({
    location                = string
    zone_redundancy_enabled = bool
    tags                    = map(string)
  }))
  default = {}
}
