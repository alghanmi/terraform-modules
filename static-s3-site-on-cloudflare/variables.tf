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

variable "redirect_to" {
  type        = string
  default     = ""
  description = "A hostname to redirect all website requests for this bucket to. Hostname can optionally be prefixed with a protocol (http:// or https://) to use when redirecting requests. The default is the protocol that is used in the original request."
}

variable "routing_rules" {
  type        = string
  default     = ""
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied."
}

variable "supplemental_src_ip_allow_list" {
  type        = list(string)
  default     = []
  description = "Additional IPs to add to the allow-list alongside Cloudflare's sources"
}

variable "logs_bucket" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map
  default = {}
}
