output "ses_domain" {
  value = aws_ses_domain_identity.default.id
}

output "ses_verification_dns_record" {
  value = {
    name  = cloudflare_record.ses_verification.name
    value = cloudflare_record.ses_verification.value
    type  = cloudflare_record.ses_verification.type
  }
}
