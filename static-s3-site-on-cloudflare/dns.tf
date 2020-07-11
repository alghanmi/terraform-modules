resource "cloudflare_record" "site" {
  zone_id = var.cloudflare_domain.id
  name    = var.site_fqdn
  type    = "CNAME"
  value   = aws_s3_bucket.site.website_endpoint
  ttl     = 1
  proxied = true
}
