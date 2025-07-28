variable "environment_prefix" {
  description = "Environment prefix for resource naming"
  type        = string
}

variable "organization_id" {
  description = "AWS Organization ID for organization trail"
  type        = string
  default     = null
}

variable "is_organization_trail" {
  description = "Whether this is an organization trail"
  type        = bool
  default     = true
}

variable "data_events" {
  description = "List of data events to monitor"
  type = list(object({
    read_write_type                  = string
    include_management_events        = bool
    exclude_management_event_sources = list(string)
    data_resource = list(object({
      type   = string
      values = list(string)
    }))
  }))
  default = []
}

variable "insight_events" {
  description = "List of insight events to monitor"
  type = list(object({
    insight_type = string
  }))
  default = []
}

variable "management_account_id" {
  description = "Management account ID for cross-account access"
  type        = string
  default     = null
}

variable "enable_security_monitoring" {
  description = "Enable CloudWatch metric filters and alarms for security monitoring"
  type        = bool
  default     = true
}

variable "enable_cross_account_access" {
  description = "Enable cross-account access role for audit account"
  type        = bool
  default     = true
}

variable "audit_account_id" {
  description = "Audit account ID for cross-account access"
  type        = string
  default     = null
}

variable "external_id" {
  description = "External ID for cross-account access"
  type        = string
  default     = "cloudtrail-security-access-2024"
}
