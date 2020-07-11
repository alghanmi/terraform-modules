output "src_ip_allow_list" {
  value = local.src_ip_allow_list
}

output "site_endpoint" {
  value = aws_s3_bucket.site.website_endpoint
}

output "site_bucket" {
  value = aws_s3_bucket.site.bucket
}

output "site_fqdn" {
  value = cloudflare_record.site.hostname
}
