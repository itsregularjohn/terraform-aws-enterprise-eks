data "aws_s3_bucket" "this" {
  bucket = "jp-terraform-showcase-terraform"
}

data "aws_caller_identity" "current" {}