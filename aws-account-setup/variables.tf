variable "aws_account_alias" {
  type    = string
  default = ""
}

variable "aws_console_admin_user" {
  type = object({
    name = string

  })
  default = {
    name    = "console-admin"
    pgp_key = "keybase:alghanmi"
  }
}
