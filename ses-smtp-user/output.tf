output "users" {
  value = {
    for u in aws_iam_access_key.ses_user :
    u.user => { username : u.id, password : u.ses_smtp_password_v4 }
  }
  sensitive = true
}
