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
  normalized_domain_name = replace(var.domain, ".", "-")
  s3_object_prefix       = format("mail-%s/", replace(var.domain, ".", "-"))

  create_ses_receipt_rule_set = var.ses_receipt_rule_set == "" ? 1 : 0
  ses_receipt_rule_set_name   = local.create_ses_receipt_rule_set == 0 ? var.ses_receipt_rule_set : aws_ses_receipt_rule_set.receive_all[0].rule_set_name

  forwarder_from_email = format("no-reply@%s", var.domain)

  dmarc_fo  = var.dmarc_record.failure_reports_options != "" ? format("fo=%s", var.dmarc_record.failure_reports_options) : ""
  dmarc_rua = length(var.dmarc_record.reporting_uri) > 0 ? format("rua=%s", join(",", var.dmarc_record.reporting_uri)) : ""
  dmarc_ruf = length(var.dmarc_record.forensic_uri) > 0 ? format("ruf=%s", join(",", var.dmarc_record.forensic_uri)) : ""
}
