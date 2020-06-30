resource "aws_sns_topic" "bounce" {
  name = format("%s-ses-bounce", local.normalized_domain_name)
  tags = var.tags
}

resource "aws_ses_identity_notification_topic" "bounce" {
  topic_arn                = aws_sns_topic.bounce.arn
  notification_type        = "Bounce"
  identity                 = aws_ses_domain_identity.default.domain
  include_original_headers = true
}

resource "aws_sns_topic" "complaint" {
  name = format("%s-ses-complaint", local.normalized_domain_name)
  tags = var.tags
}

resource "aws_ses_identity_notification_topic" "complaint" {
  topic_arn                = aws_sns_topic.complaint.arn
  notification_type        = "Complaint"
  identity                 = aws_ses_domain_identity.default.domain
  include_original_headers = true
}
