resource "aws_sns_topic" "state_changes" {
  name = "terraform-state-changes"
}

resource "aws_sns_topic_policy" "state_changes" {
  arn = aws_sns_topic.state_changes.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.state_changes.arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [data.aws_s3_bucket.this.arn]
    }
  }
}
