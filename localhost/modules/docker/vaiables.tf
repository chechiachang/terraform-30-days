variable "images" {
  type    = set(string)
  default = []
}

variable "containers" {
  type = map(object({
    name       = string
    image      = string
    command    = list(string)
    env        = set(string)
    privileged = bool
    restart    = string

    ports = map(object({
      internal = number
      external = number
    }))
  }))
  default = {}
}
