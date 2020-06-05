resource "aws_iam_account_alias" "alias" {
  account_alias = var.aws_account_alias
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 32
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_iam_user" "admin_console_user" {
  name          = var.aws_console_admin_user.name
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "admin_console_user" {
  user    = aws_iam_user.admin_console_user.name
  pgp_key = var.aws_console_admin_user.pgp_key

  lifecycle {
    ignore_changes = [ password_length, password_reset_required, pgp_key ]
  }
}
