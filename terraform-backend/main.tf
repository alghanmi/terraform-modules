resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.prefix}-terraform-state-${var.s3_bucket_suffix}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "tf_state_lock" {
  name           = "${var.prefix}-terraform-statelock"
  billing_mode   = "PROVISIONED"
  hash_key       = "LockID"
  write_capacity = 1
  read_capacity  = 2

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}
