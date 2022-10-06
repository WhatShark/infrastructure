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

resource "aws_kms_key" "main-dnssec-key" {
  provider                 = aws.us-east-1
  description              = "Used for signing and verifying DNSSEC requests for whatshark.com"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  policy                   = data.aws_iam_policy_document.route53-dnssec-policy.json
}

resource "aws_kms_alias" "main-dnssec-key-alias" {
  name          = "alias/main-dnssec-key"
  target_key_id = aws_kms_key.main-dnssec-key.key_id
}

resource "aws_route53_zone" "main" {
  name = "whatshark.com"
}

resource "aws_route53_key_signing_key" "main-dnssec-key" {
  name                       = "whatshark-dnssec"
  hosted_zone_id             = aws_route53_zone.main.id
  key_management_service_arn = aws_kms_key.main-dnssec-key.arn
}

resource "aws_route53_hosted_zone_dnssec" "main-dnssec-key-record" {
  depends_on = [
    aws_route53_key_signing_key.main-dnssec-key
  ]
  hosted_zone_id = aws_route53_key_signing_key.main-dnssec-key.hosted_zone_id
}