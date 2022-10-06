resource "aws_kms_key" "main-dnssec-key" {
  provider                 = aws.us-east-1
  description              = "Used for signing and verifying DNSSEC requests for whatshark.com"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  policy                   = data.aws_iam_policy_document.route53-dnssec-policy.json
}

resource "aws_kms_alias" "main-dnssec-key-alias" {
  provider = aws.us-east-1
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