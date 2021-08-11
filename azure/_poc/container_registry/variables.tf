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

# Docker Image

variable "images" {
  type    = set(string)
  default = []
}
