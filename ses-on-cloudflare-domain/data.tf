data "aws_caller_identity" "current" {}

data "aws_s3_bucket_object" "forwarder_lambda_source_code" {
  bucket = var.lambda_function_specs.bucket
  key    = var.lambda_function_specs.key
}

data "aws_s3_bucket_object" "forwarder_lambda_source_code_hash" {
  bucket = var.lambda_function_specs.bucket
  key    = var.lambda_function_specs.hash_key
}

locals {
  s3_object_prefix       = format("mail-%s/", replace(var.domain, ".", "-"))
  normalized_domain_name = replace(var.domain, ".", "-")
  forwarder_from_email   = format("no-reply@%s", var.domain)
}
