data "aws_iam_policy_document" "ses_allow_send" {
  statement {
    effect = "Allow"

    actions = [
      "ses:SendRawEmail",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_user" "ses_user" {
  count         = length(var.users)
  name          = var.users[count.index].name
  path          = var.users[count.index].path
  force_destroy = var.users[count.index].force_destroy
  tags          = var.tags
}

resource "aws_iam_user_policy" "ses_user" {
  count  = length(aws_iam_user.ses_user)
  name   = format("ses-user-%s-policy", aws_iam_user.ses_user[count.index].name)
  policy = data.aws_iam_policy_document.ses_allow_send.json
  user   = aws_iam_user.ses_user[count.index].name
}

resource "aws_iam_access_key" "ses_user" {
  count   = length(aws_iam_user.ses_user)
  user    = aws_iam_user.ses_user[count.index].name
  pgp_key = [for u in var.users : u.pgp_key if u.name == aws_iam_user.ses_user[count.index].name][0]
  status  = [for u in var.users : u.is_active if u.name == aws_iam_user.ses_user[count.index].name][0] == true ? "Active" : "Inactive"
}
