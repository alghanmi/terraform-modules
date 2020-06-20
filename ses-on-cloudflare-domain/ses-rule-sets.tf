resource "aws_ses_receipt_rule_set" "receive_all" {
  rule_set_name = format("%s-receive-all-rule-set", replace(aws_ses_domain_identity.default.domain, ".", "-"))
}

resource "aws_ses_active_receipt_rule_set" "receive_all" {
  rule_set_name = aws_ses_receipt_rule_set.receive_all.rule_set_name
}

resource "aws_ses_receipt_rule" "receive_all" {
  name          = format("%s-receive-all", replace(aws_ses_domain_identity.default.domain, ".", "-"))
  rule_set_name = aws_ses_receipt_rule_set.receive_all.rule_set_name

  enabled      = true
  scan_enabled = true

  add_header_action {
    header_name  = "X-MAIL-PROCESSOR"
    header_value = "Processed by SES"
    position     = 1
  }

  s3_action {
    bucket_name = aws_s3_bucket.mail.bucket
    position    = 2
  }
}
