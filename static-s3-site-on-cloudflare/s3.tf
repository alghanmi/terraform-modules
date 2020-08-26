resource "aws_s3_bucket" "site" {
  bucket = var.site_fqdn
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  website {
    index_document = var.index_document
    error_document = var.error_document
    routing_rules  = var.routing_rules
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }

  logging {
    target_bucket = data.aws_s3_bucket.logs.bucket
    target_prefix = format("site-logs-%s/", replace(var.site_fqdn, ".", "-"))
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "site_s3_cloudfront_policy" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.allow_s3_from_cloudfront.json
}
