variable "users" {
  type = list(object({
    name          = string
    path          = string
    is_active     = bool
    force_destroy = bool
    pgp_key       = string
  }))

  default = []
}

variable "tags" {
  type    = map
  default = {}
}
