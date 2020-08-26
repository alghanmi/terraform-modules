resource "cloudflare_record" "site" {
  zone_id = var.cloudflare_domain.id
  name    = var.site_fqdn
  type    = "CNAME"
  value   = aws_cloudfront_distribution.site.domain_name
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "aliases" {
  count = length(local.aliases)

  zone_id = var.cloudflare_domain.id
  name    = format("%s", trimsuffix(local.aliases[count.index], format(".%s", var.site_fqdn)))
  type    = "CNAME"
  value   = aws_cloudfront_distribution.site.domain_name
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "certificate_validation" {
  count = length(local.domain_list)

  zone_id = var.cloudflare_domain.id
  name    = format("%s", aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_name)
  type    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_type
  value   = trimsuffix(aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_value, ".")
  ttl     = 1
}
