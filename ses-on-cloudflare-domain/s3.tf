resource "aws_s3_bucket" "mail" {
  bucket = format("mail-%s-%s-%s", replace(var.domain, ".", "-"), var.ses_region, var.domain_zone_id)
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ses_puts_s3" {
  statement {
    sid    = "AllowSESPuts"
    effect = "Allow"

    principals {
      identifiers = ["ses.amazonaws.com"]
      type        = "Service"
    }

    actions   = ["s3:PutObject"]
    resources = [format("%s/*", aws_s3_bucket.mail.arn)]

    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:Referer"
    }
  }
}

resource "aws_s3_bucket_policy" "mail" {
  bucket = aws_s3_bucket.mail.id
  policy = data.aws_iam_policy_document.ses_puts_s3.json
}
