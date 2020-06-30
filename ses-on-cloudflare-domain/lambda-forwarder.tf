data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name               = format("%s-ses-lambda-role", local.normalized_domain_name)
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = [format("arn:aws:ses:%s:%s:identity/*", var.ses_region, data.aws_caller_identity.current.account_id)]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [format("%s/*", aws_s3_bucket.mail.arn)]
  }
}

resource "aws_iam_policy" "lambda" {
  name   = format("%s-ses-lambda-policy", local.normalized_domain_name)
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

data "archive_file" "forwarder" {
  type        = "zip"
  source_dir  = "${path.module}/scripts/aws-lambda-ses-forwarder"
  output_path = "${path.module}/scripts/aws-lambda-ses-forwarder.zip"
}

resource "aws_lambda_function" "forwarder" {
  filename         = data.archive_file.forwarder.output_path
  function_name    = format("%s-aws-lambda-ses-forwarder", local.normalized_domain_name)
  role             = aws_iam_role.lambda.arn
  source_code_hash = data.archive_file.forwarder.output_base64sha256
  runtime          = "nodejs12.x"
  handler          = "index.handler"
  environment {
    variables = {
      "EMAIL_BUCKET_NAME"     = aws_s3_bucket.mail.bucket
      "EMAIL_BUCKET_PATH"     = local.s3_object_prefix
      "EMAIL_FROM"            = local.forwarder_from_email
      "EMAIL_ALLOW_PLUS_SIGN" = "true"
      "EMAIL_MAPPING"         = jsonencode(var.forwarder_mapping)
    }
  }
  tags = var.tags
}

resource "aws_lambda_alias" "forwarder" {
  name             = "ses-email-forwarder"
  description      = format("ses-email-forwarder for %s", aws_ses_domain_identity.default.domain)
  function_name    = aws_lambda_function.forwarder.arn
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "AllowExecutionFromSES"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.forwarder.function_name
  principal      = "ses.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
}
