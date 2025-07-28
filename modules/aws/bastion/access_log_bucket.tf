resource "aws_s3_bucket" "access_log_bucket" {
  bucket        = "${var.vpc_name}-bastion-ssm-access"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "access_log_bucket" {
  bucket = aws_s3_bucket.access_log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "access_log_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.access_log_bucket]

  bucket = aws_s3_bucket.access_log_bucket.id
  acl    = "log-delivery-write"
}


resource "aws_s3_bucket_versioning" "access_log_bucket" {
  bucket = aws_s3_bucket.access_log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "access_log_bucket" {
  bucket = aws_s3_bucket.access_log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ssmkey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "access_log_bucket" {
  bucket = aws_s3_bucket.access_log_bucket.id

  rule {
    id     = "delete_after_X_days"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = var.access_log_expire_days
    }
  }
}


resource "aws_s3_bucket_public_access_block" "access_log_bucket" {
  bucket                  = aws_s3_bucket.access_log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
