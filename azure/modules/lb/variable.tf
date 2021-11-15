variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

# lb

variable "public_ip_allocation_method" {
  type    = string
  default = "Static"
}

variable "protocol" {
  type    = string
  default = "Tcp"
}

variable "frontend_port_start" {
  type    = number
  default = 80
}

variable "frontend_port_end" {
  type    = number
  default = 80
}

variable "backend_port" {
  type    = number
  default = 80
}


