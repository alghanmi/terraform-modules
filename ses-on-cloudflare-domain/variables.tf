variable "domain" {
  type        = string
  description = "DNS Zone name used for SES Setup"
}

variable "domain_zone_id" {
  type        = string
  description = "Cloudflare zone id"
}

variable "mailfrom_subdomain" {
  type        = string
  description = "Subdomain used for SES MAIL FROM. See https://docs.aws.amazon.com/ses/latest/DeveloperGuide/mail-from.html"
  default     = "mail"
}

variable "ses_region" {
  type        = string
  description = "AWS region for the SES sending endpoint"
}

variable "spf_record" {
  type        = string
  description = "Sender Policy Framework (SPF) for SES. https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-spf.html"
  default     = "v=spf1 include:amazonses.com -all"
}

variable "tags" {
  type = map
  default = {
    managed-by = "terraform"
  }
}
