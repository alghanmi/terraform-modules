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
  default     = "v=spf1 include:amazonses.com ~all"
}

variable "dmarc_record" {
  type = object({
    policy                  = string
    percentage              = number
    reporting_uri           = list(string) # emails must be prefixed with `mailto:`
    forensic_uri            = list(string) # emails must be prefixed with `mailto:`
    failure_reports_options = string
  })

  default = {
    policy                  = "reject"
    percentage              = 100
    reporting_uri           = []
    forensic_uri            = []
    failure_reports_options = 1
  }
}

variable "ses_receipt_rule_set" {
  type    = string
  default = ""
}

variable "lambda_function_specs" {
  type = object({
    bucket   = string
    key      = string
    hash_key = string
    runtime  = string
    handler  = string

  })
  description = "Specifications for the SES lamba function"
  default = {
    bucket   = "lambda-source-code"
    key      = "aws-lambda-ses-forwarder.zip"
    hash_key = "aws-lambda-ses-forwarder.zip.sha256base64"
    runtime  = "nodejs12.x"
    handler  = "index.handler"
  }
}

variable "forwarder_mapping" {
  type        = map(list(string))
  description = "Object where the key is the lowercase email address from which to forward and the value is an array of email addresses to which to send the message."
  default = {
    "info@example.com" : ["example.john@example.com", "example.jen@example.com"],
    "abuse@example.com" : ["example.jim@example.com"],
    "@example.com" : ["example.john@example.com"],
    "info" : ["info@example.com"]
  }
}

variable "tags" {
  type = map
  default = {
    managed-by = "terraform"
  }
}
