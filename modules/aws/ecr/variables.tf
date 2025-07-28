variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "kms_key_id" {
  description = "KMS key ID for repository encryption. Use the output from the ecr-kms module"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "enable_image_scanning" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "enable_lifecycle_policy" {
  description = "Enable lifecycle policy to manage image retention"
  type        = bool
  default     = true
}

variable "lifecycle_policy_untagged_image_count" {
  description = "Number of untagged images to keep"
  type        = number
  default     = 5
}

variable "lifecycle_policy_tagged_image_count" {
  description = "Number of tagged images to keep"
  type        = number
  default     = 10
}

variable "lifecycle_policy_tag_prefixes" {
  description = "List of tag prefixes to apply lifecycle policy to"
  type        = list(string)
  default     = ["v", "latest", "main", "master", "develop"]
}

variable "repository_policy" {
  description = "JSON policy document for the ECR repository. Leave null for no policy"
  type        = string
  default     = null
}