
output "console_admin_user" {
  value = aws_iam_user.admin_console_user.user
}

output "console_admin_password" {
  value = aws_iam_user_login_profile.admin_console_user.encrypted_password
}
