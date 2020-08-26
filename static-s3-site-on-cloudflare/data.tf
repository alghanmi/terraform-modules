locals {
  domain_list = compact(concat(var.tls_certificate_sans, [var.site_fqdn]))
  aliases     = compact(var.tls_certificate_sans)
}

data "aws_s3_bucket" "logs" {
  bucket = var.logs_bucket
}
