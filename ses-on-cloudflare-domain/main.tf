resource "aws_ses_domain_identity" "default" {
  domain = var.domain
}

resource "cloudflare_record" "ses_verification" {
  zone_id = var.domain_zone_id
  name    = "_amazonses.${aws_ses_domain_identity.default.id}"
  type    = "TXT"
  ttl     = "3600"
  value   = aws_ses_domain_identity.default.verification_token
}

resource "aws_ses_domain_identity_verification" "default" {
  domain = aws_ses_domain_identity.default.id

  depends_on = [cloudflare_record.ses_verification]
}

resource "aws_ses_domain_dkim" "default" {
  domain     = aws_ses_domain_identity.default.domain

  depends_on = [aws_ses_domain_identity_verification.default]
}

resource "cloudflare_record" "default_dkim" {
  count   = length(aws_ses_domain_dkim.default.dkim_tokens)
  zone_id = var.domain_zone_id
  name    = "${aws_ses_domain_dkim.default.dkim_tokens[count.index]}._domainkey.${aws_ses_domain_dkim.default.domain}"
  type    = "CNAME"
  ttl     = "600"
  value   = "${aws_ses_domain_dkim.default.dkim_tokens[count.index]}.dkim.amazonses.com"
}
