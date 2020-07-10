resource "aws_ses_receipt_rule_set" "receive_all" {
  count         = local.create_ses_receipt_rule_set
  rule_set_name = format("%s-receive-all-rule-set", local.normalized_domain_name)
}

resource "aws_ses_active_receipt_rule_set" "receive_all" {
  count         = local.create_ses_receipt_rule_set
  rule_set_name = aws_ses_receipt_rule_set.receive_all[0].rule_set_name
}

resource "aws_ses_receipt_rule" "receive_all" {
  name          = format("%s-receive-all", local.normalized_domain_name)
  rule_set_name = local.ses_receipt_rule_set_name
  recipients    = [aws_ses_domain_identity.default.domain]

  enabled      = true
  scan_enabled = true

  add_header_action {
    header_name  = "X-MAIL-PROCESSOR"
    header_value = "Processed by SES"
    position     = 1
  }

  s3_action {
    bucket_name       = aws_s3_bucket.mail.bucket
    object_key_prefix = local.s3_object_prefix
    position          = 2
  }

  lambda_action {
    function_arn = aws_lambda_function.forwarder.arn
    position     = 3
  }

  depends_on = [
    aws_s3_bucket_policy.mail,
    aws_lambda_permission.allow_ses
  ]
}
