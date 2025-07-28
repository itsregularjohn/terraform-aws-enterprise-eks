module "cloudtrail_organization" {
  source = "../../../../modules/aws/cloudtrail"

  environment_prefix = local.environment_prefix

  organization_id       = local.organization_id
  management_account_id = local.management_account_id

  enable_security_monitoring   = true
  enable_cross_account_access  = true
  audit_account_id             = local.audit_account_id
  external_id                  = local.external_id

  data_events = [
    {
      read_write_type                  = "All"
      include_management_events        = true
      exclude_management_event_sources = []
      data_resource = [
        {
          type = "AWS::S3::Object"
          values = [
            "arn:aws:s3:::jp-terraform-showcase-terraform/*",
            "arn:aws:s3:::*-cloudtrail-logs/*"
          ]
        },
        {
          type = "AWS::S3::Bucket"
          values = [
            "arn:aws:s3:::jp-terraform-showcase-terraform",
            "arn:aws:s3:::*-cloudtrail-logs"
          ]
        }
      ]
    }
  ]

  insight_events = [
    {
      insight_type = "ApiCallRateInsight"
    }
  ]
}
