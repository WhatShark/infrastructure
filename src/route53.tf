resource "aws_kms_key" "main-dnssec-key" {
  description              = "Used for signing and verifying DNSSEC requests for whatshark.com"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  policy = jsonencode({
    Version = "2012-10-17"
    id = "dnssec-policy"
    Statement = [
      {
        Sid    = "Allow Route 53 DNSSEC Service"
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${data.aws_caller_identity.current.account_id}"
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:route53:::hostedzone/*"
          }
        }
      },
      {
        Sid    = "Allow Route 53 DNSSEC Service to CreateGrant"
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Action   = "kms:CreateGrant"
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
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