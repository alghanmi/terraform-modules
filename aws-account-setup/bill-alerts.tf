resource "aws_sns_topic" "account_alerts" {
  name = var.sns_topic_account_alerts
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "account_bill_alarm" {
  alarm_name          = "bill-alarm-${lower(var.alarm_bill.currency)}-${aws_iam_account_alias.alias.account_alias}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"
  statistic           = "Maximum"
  threshold           = var.alarm_bill.monthly_threshold
  alarm_actions       = [ aws_sns_topic.account_alerts.arn ]
  alarm_description   = var.alarm_bill.description

  dimensions = {
    Currency = "${upper(var.alarm_bill.currency)}"
  }
}

resource "aws_budgets_budget" "account_budget" {
  name              = "account-monthly-budget"
  budget_type       = var.budget_overall_cost.budget_type
  limit_amount      = var.budget_overall_cost.limit_amount
  limit_unit        = var.budget_overall_cost.limit_unit
  time_period_start = "2020-01-01_00:00"
  time_unit         = var.budget_overall_cost.time_unit

  dynamic "notification" {
    for_each = var.budget_overall_cost.notification_threshold
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_email_addresses = compact(var.budget_overall_cost.subscriber_emails)
      subscriber_sns_topic_arns  = compact(concat(var.budget_overall_cost.subscriber_sns, [aws_sns_topic.account_alerts.arn]))
    }
  }
}
