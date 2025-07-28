resource "aws_cloudtrail" "this" {
  name = local.name

  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.this.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudwatch_logs.arn
  include_global_service_events = true

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/cloudtrail/enable-log-validation/
  enable_log_file_validation = true

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/cloudtrail/enable-at-rest-encryption/
  kms_key_id = aws_kms_key.this.arn

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/cloudtrail/enable-all-regions/
  is_multi_region_trail = true

  is_organization_trail = var.is_organization_trail

  s3_bucket_name = aws_s3_bucket.this.id
  depends_on     = [aws_s3_bucket_policy.this]

  dynamic "event_selector" {
    for_each = var.data_events
    content {
      read_write_type                  = event_selector.value.read_write_type
      include_management_events        = event_selector.value.include_management_events
      exclude_management_event_sources = event_selector.value.exclude_management_event_sources

      dynamic "data_resource" {
        for_each = event_selector.value.data_resource
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }

  dynamic "insight_selector" {
    for_each = var.insight_events
    content {
      insight_type = insight_selector.value.insight_type
    }
  }
}
