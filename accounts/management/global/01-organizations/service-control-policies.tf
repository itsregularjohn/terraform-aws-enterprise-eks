data "aws_iam_policy_document" "sandbox_scp" {
  statement {
    effect = "Deny"
    actions = [
      "organizations:*",
      "account:*",
      "trustedadvisor:*",
      "support:*"
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values = [
        "us-east-1",
        "sa-east-1",
        "us-west-2"
      ]
    }
  }
}

resource "aws_organizations_policy" "sandbox_scp" {
  name        = "SandboxSCP"
  description = "Service Control Policy for Sandbox accounts"
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.sandbox_scp.json

  tags = {
    Name = "Sandbox SCP"
    Type = "SCP"
  }
}

resource "aws_organizations_policy_attachment" "sandbox_scp" {
  policy_id = aws_organizations_policy.sandbox_scp.id
  target_id = aws_organizations_organizational_unit.sandbox.id
}
