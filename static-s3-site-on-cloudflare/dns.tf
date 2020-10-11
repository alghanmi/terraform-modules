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
  for_each = {
    for validation_option in aws_acm_certificate.cert.domain_validation_options : validation_option.domain_name => {
      record_name  = validation_option.resource_record_name
      record_type  = validation_option.resource_record_type
      record_value = validation_option.resource_record_value
    }
  }

  zone_id = var.cloudflare_domain.id
  name    = format("%s", each.value.record_name)
  type    = each.value.record_type
  value   = trimsuffix(each.value.record_value, ".")
  ttl     = 1
}
