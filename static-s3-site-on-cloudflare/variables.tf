variable "cloudflare_domain" {
  type = object({
    name = string
    id   = string
  })
  default = {
    name = ""
    id   = ""
  }
}

variable "site_fqdn" {
  type    = string
  default = ""
}

variable "tls_certificate_sans" {
  type    = list(string)
  default = [""]
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}

variable "routing_rules" {
  type        = string
  default     = ""
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied."
}

variable "logs_bucket" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map
  default = {}
}
