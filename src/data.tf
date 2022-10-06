data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "route53-dnssec-policy" {
  version = "2012-10-17"
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "Allow Route 53 DNSSEC Service"
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GetPublicKey",
      "kms:Sign"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:route53:::hostedzone/*"]
    }
    principals {
      type        = "Service"
      identifiers = ["dnssec-route53.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow Route 53 DNSSEC to CreateGrant"
    effect    = "Allow"
    actions   = ["kms:CreateGrant"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["dnssec-route53.amazonaws.com"]
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
  }
}
