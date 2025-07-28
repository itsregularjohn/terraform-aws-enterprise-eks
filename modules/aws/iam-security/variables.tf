variable "enable_password_policy" {
  description = "Enable IAM account password policy"
  type        = bool
  default     = true
}

variable "minimum_password_length" {
  description = "Minimum length to require for user passwords"
  type        = number
  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/set-minimum-password-length/
  default     = 14
  validation {
    condition     = var.minimum_password_length >= 14
    error_message = "Minimum password length must be at least 14 characters for security compliance."
  }
}

variable "max_password_age" {
  description = "Number of days that an user password is valid"
  type        = number
  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/set-max-password-age/
  default     = 90
}

variable "password_reuse_prevention" {
  description = "Number of previous passwords that users are prevented from reusing"
  type        = number
  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/no-password-reuse/
  default     = 5
  validation {
    condition     = var.password_reuse_prevention >= 5
    error_message = "Password reuse prevention must be at least 5 for security compliance."
  }
}

variable "require_lowercase_characters" {
  description = "Whether to require lowercase characters for user passwords"
  type        = bool
  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/require-lowercase-in-passwords/
  default     = true
}

variable "require_numbers" {
  description = "Whether to require numbers for user passwords"
  type        = bool
  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/require-numbers-in-passwords/
  default     = true
}

variable "require_uppercase_characters" {
  description = "Whether to require uppercase characters for user passwords"
  type        = bool
  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/require-uppercase-in-passwords/
  default     = true
}

variable "require_symbols" {
  description = "Whether to require symbols for user passwords"
  type        = bool
  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/require-symbols-in-passwords/
  default     = true
}

variable "allow_users_to_change_password" {
  description = "Whether to allow users to change their own password"
  type        = bool
  default     = true
}

variable "hard_expiry" {
  description = "Whether users are prevented from setting a new password after their password has expired"
  type        = bool
  default     = false
}

variable "enable_mfa_enforcement" {
  description = "Enable MFA enforcement policy for all users"
  type        = bool
  default     = true
}

variable "iam_groups" {
  description = "Map of IAM groups to create"
  type = map(object({
    path                = optional(string, "/")
    aws_managed_policies = optional(list(string), [])
    custom_policies     = optional(list(string), [])
  }))
  default = {}
}

variable "iam_policies" {
  description = "Map of custom IAM policies to create"
  type = map(object({
    path            = optional(string, "/")
    description     = string
    policy_document = string
  }))
  default = {}
}

variable "iam_roles" {
  description = "Map of IAM roles to create"
  type = map(object({
    description          = string
    assume_role_policy   = string
    path                = optional(string, "/")
    max_session_duration = optional(number, 3600)
    aws_managed_policies = optional(list(string), [])
    custom_policies     = optional(list(string), [])
  }))
  default = {}
}

variable "group_memberships" {
  description = "Map of group names to list of users"
  type        = map(list(string))
  default     = {}
}