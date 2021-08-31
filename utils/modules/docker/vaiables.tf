variable "images" {
  type    = set(string)
  default = []
}

variable "containers" {
  type = map(object({
    name       = string
    image      = string
    entrypoint = string
  }))
  default = {}
}
