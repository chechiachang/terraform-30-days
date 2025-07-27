variable "resource_group_name" {
  type = string
}

variable "subscription_id" {
  type = string
}

# Network

variable "address_space" {
  type = string
}

variable "subnet_prefixes" {
  type = list(string)
}

variable "subnet_names" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
