resource "aws_s3_bucket" "session_logs_bucket" {
  bucket = "${var.vpc_name}-bastion-ssm-session"
}

resource "aws_s3_bucket_ownership_controls" "session_logs_bucket" {
  bucket = aws_s3_bucket.session_logs_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "session_logs_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.session_logs_bucket]

  bucket = aws_s3_bucket.session_logs_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "session_logs_bucket" {
  bucket = aws_s3_bucket.session_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "session_logs_bucket" {
  bucket = aws_s3_bucket.session_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ssmkey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "session_logs_bucket" {
  bucket = aws_s3_bucket.session_logs_bucket.id

  rule {
    id     = "archive_after_X_days"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.log_archive_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.log_expire_days
    }
  }
}


resource "aws_s3_bucket_logging" "session_logs_bucket" {
  bucket = aws_s3_bucket.session_logs_bucket.id

  target_bucket = aws_s3_bucket.session_logs_bucket.id
  target_prefix = "log/"
}


resource "aws_s3_bucket_public_access_block" "session_logs_bucket" {
  bucket                  = aws_s3_bucket.session_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
