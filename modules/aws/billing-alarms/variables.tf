variable "account_name" {
  description = "Name of the AWS account for alarm naming"
  type        = string
}

variable "alarm_email" {
  description = "Email address to receive billing alarm notifications"
  type        = string
}
