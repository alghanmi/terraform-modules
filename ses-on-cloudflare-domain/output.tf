output "ses_domain" {
  value = aws_ses_domain_identity.default.id
}

output "notification_topics" {
  value = {
    bounce    = aws_sns_topic.bounce.arn
    complaint = aws_sns_topic.complaint.arn
  }
}

output "ses_verification_dns_record" {
  value = {
    name  = cloudflare_record.ses_verification.name
    value = cloudflare_record.ses_verification.value
    type  = cloudflare_record.ses_verification.type
  }
}

output "ses_receipt" {
  value = {
    rule     = aws_ses_receipt_rule.receive_all.name
    rule_set = aws_ses_receipt_rule_set.receive_all.rule_set_name
  }
}

output "lambda_function" {
  value = aws_lambda_function.forwarder.function_name
}

output "s3_bucket" {
  value = aws_s3_bucket.mail.id
}

output "dns_records" {
  value = {
    spf   = cloudflare_record.default_spf.name
    dmarc = cloudflare_record.default_dmarc.name
    mx    = cloudflare_record.default_mx.name
  }
}

output "mailfrom_dns_records" {
  value = {
    spf = cloudflare_record.mailfrom_spf.name
    mx  = cloudflare_record.mailfrom_mx.name
  }
}