data "aws_caller_identity" "current" {}

locals {
  s3_object_prefix       = format("mail-%s/", replace(var.domain, ".", "-"))
  normalized_domain_name = replace(var.domain, ".", "-")
  forwarder_from_email   = format("no-reply@%s", var.domain)
}
