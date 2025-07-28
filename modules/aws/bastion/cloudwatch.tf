resource "aws_cloudwatch_log_group" "session_manager_log_group" {
  name_prefix       = "${var.cloudwatch_log_group_name}-"
  retention_in_days = var.cloudwatch_logs_retention
  kms_key_id        = aws_kms_key.ssmkey.arn
}