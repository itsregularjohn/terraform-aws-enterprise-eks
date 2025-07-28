variable "name" {
  description = "Base name for the KMS key and alias"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
  default     = "production"
}

variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key"
  type        = number
  default     = 7
  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "The deletion window must be between 7 and 30 days."
  }
}

variable "enable_key_rotation" {
  description = "Specifies whether annual key rotation is enabled"
  type        = bool
  default     = true
}