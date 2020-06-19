variable "aws_account_alias" {
  type    = string
  default = "aws-account"
}

variable "aws_console_admin_user" {
  type = object({
    name    = string
    pgp_key = string
  })
  default = {
    name    = "console-admin"
    pgp_key = "keybase:alghanmi"
  }
}

variable "sns_topic_account_alerts" {
  type    = string
  default = "account-alerts"
}

variable "alarm_bill" {
  type = object({
    monthly_threshold = number
    currency          = string
    description       = string
  })
  default = {
    monthly_threshold = "100.00"
    currency          = "USD"
    description       = "Monthly account billing alarm"
  }
}

variable "budget_overall_cost" {
  type = object({
    budget_type            = string
    limit_amount           = number
    limit_unit             = string
    time_unit              = string
    notification_threshold = list(number)
    subscriber_emails      = list(string)
    subscriber_sns         = list(string)
  })
  default = {
    budget_type            = "COST"
    limit_amount           = "100"
    limit_unit             = "USD"
    time_unit              = "MONTHLY"
    notification_threshold = [50, 80, 100]
    subscriber_emails      = []
    subscriber_sns         = []
  }
}

variable "tags" {
  type = map
  default = {
    managed-by = "terraform"
  }
}
