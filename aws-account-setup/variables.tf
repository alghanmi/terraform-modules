variable "aws_account_alias" {
  type    = string
  default = "aws-account"
}

variable "aws_console_admin_user" {
  type = object({
    name    = string
    pgp_key = string
  })
  default = {
    name    = "console-admin"
    pgp_key = "keybase:alghanmi"
  }
}
