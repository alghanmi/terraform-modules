## SES Domain Verification
resource "aws_ses_domain_identity" "default" {
  domain = var.domain
}

resource "cloudflare_record" "ses_verification" {
  zone_id = var.domain_zone_id
  name    = format("_amazonses.%s", aws_ses_domain_identity.default.domain)
  type    = "TXT"
  ttl     = "3600"
  value   = aws_ses_domain_identity.default.verification_token
}

resource "aws_ses_domain_identity_verification" "default" {
  domain = aws_ses_domain_identity.default.domain

  depends_on = [cloudflare_record.ses_verification]
}

## DKIM Setup
resource "aws_ses_domain_dkim" "default" {
  domain = aws_ses_domain_identity.default.domain

  depends_on = [aws_ses_domain_identity_verification.default]
}

resource "cloudflare_record" "default_dkim" {
  count   = length(aws_ses_domain_dkim.default.dkim_tokens)
  zone_id = var.domain_zone_id
  name    = format("%s._domainkey.%s", aws_ses_domain_dkim.default.dkim_tokens[count.index], aws_ses_domain_dkim.default.domain)
  type    = "CNAME"
  ttl     = "3600"
  value   = format("%s.dkim.amazonses.com", aws_ses_domain_dkim.default.dkim_tokens[count.index])
}

## SPF Record
resource "cloudflare_record" "default_spf" {
  zone_id = var.domain_zone_id
  name    = aws_ses_domain_identity.default.domain
  type    = "TXT"
  value   = var.spf_record
  ttl     = "3600"
}

## DMARC Record
resource "cloudflare_record" "default_dmarc" {
  zone_id = var.domain_zone_id
  name    = format("_dmarc.%s", aws_ses_domain_identity.default.domain)
  type    = "TXT"
  value = format("v=DMARC1; p=%s; pct=%s; rua=%s; ruf=%s; fo=%s",
    var.dmarc_record.policy,
    var.dmarc_record.percentage,
    join(",", var.dmarc_record.reporting_uri),
    join(",", var.dmarc_record.forensic_uri),
  var.dmarc_record.failure_reports_options)
  ttl = "3600"
}

## MX Record
resource "cloudflare_record" "default_mx" {
  zone_id  = var.domain_zone_id
  name     = aws_ses_domain_identity.default.domain
  type     = "MX"
  value    = format("inbound-smtp.%s.amazonaws.com", var.ses_region)
  ttl      = "3600"
  priority = 10
}

## SES Mail From Domain
resource "aws_ses_domain_mail_from" "mailfrom" {
  domain           = aws_ses_domain_identity.default.domain
  mail_from_domain = format("%s.%s", var.mailfrom_subdomain, aws_ses_domain_identity.default.domain)
}

## Mail From SPF Record
resource "cloudflare_record" "mailfrom_spf" {
  zone_id = var.domain_zone_id
  name    = aws_ses_domain_mail_from.mailfrom.mail_from_domain
  type    = "TXT"
  value   = var.spf_record
  ttl     = "3600"
}

## Mail From MX Record
resource "cloudflare_record" "mailfrom_mx" {
  zone_id  = var.domain_zone_id
  name     = aws_ses_domain_mail_from.mailfrom.mail_from_domain
  type     = "MX"
  value    = format("feedback-smtp.%s.amazonses.com", var.ses_region)
  ttl      = "3600"
  priority = 10
}
