resource "aws_s3_bucket" "site" {
  bucket = var.site_fqdn
  acl    = "public-read"
  policy = templatefile("${path.module}/bucket-public-read-policy.json.tmpl", {
    s3_bucket         = var.site_fqdn,
    src_ip_allow_list = jsonencode(local.src_ip_allow_list)
  })

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  dynamic "website" {
    for_each = local.website_block[var.redirect_to == "" ? "static_site" : "redirect_site"]
    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = [format("https://%s", var.site_fqdn), format("http://%s", var.site_fqdn)]
    expose_headers  = ["ETag"]
    max_age_seconds = 300
  }

  logging {
    target_bucket = var.logs_bucket
    target_prefix = format("site-logs-%s/", replace(var.site_fqdn, ".", "-"))
  }

  tags = var.tags
}
