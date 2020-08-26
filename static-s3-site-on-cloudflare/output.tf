output "site_bucket" {
  value = aws_s3_bucket.site.bucket
}

output "fqdn" {
  value = cloudflare_record.site.hostname
}

output "sans" {
  value = cloudflare_record.aliases.*.hostname
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.site.domain_name
}
