output "terraform_state_s3_bucket" {
  value = aws_s3_bucket.tf_state.id
}

output "terraform_state_lock_table" {
  value = aws_dynamodb_table.tf_state_lock.id
}

output "terraform_state_region" {
  value = aws_s3_bucket.tf_state.region
}
