output "aws_account_alias" {
  value = aws_iam_account_alias.alias.account_alias
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_console_url" {
  value = "https://${aws_iam_account_alias.alias.account_alias}.signin.aws.amazon.com/console"
}

output "billing_alarm" {
  value = <<-EOF
    A billing alarm has been set for account ${data.aws_caller_identity.current.account_id} with
    threshold = ${var.alarm_bill.currency} ${var.alarm_bill.monthly_threshold}.
    Any estimated charges above this amount will trigger an alarm publish to the SNS topic below.

    MUST SUBSCRIBE TO: ${aws_sns_topic.account_alerts.arn}
  EOF
}

output "console_admin_user" {
  value = aws_iam_user.admin_console_user.name
}

output "console_admin_password" {
  value = aws_iam_user_login_profile.admin_console_user.encrypted_password
}
