variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "extra_tags" {
  type = map(string)
  default = {}
}
