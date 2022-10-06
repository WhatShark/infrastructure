resource "aws_route53_record" "txt-root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "whatshark.com"
  type    = "TXT"
  ttl     = 3600
  records = [
    "keybase-site-verification=0-xAbh86MC_fqONGB5gStg6Z59JChhATmwgNEC4VS6",
    "v=spf1 include:_spf.google.com ~all"
  ]
}

resource "aws_route53_record" "mx-root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "whatshark.com"
  type    = "MX"
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com"
  ]
  ttl = 3600
}

resource "aws_route53_record" "spf-root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "whatshark.com"
  type    = "SPF"
  records = ["v=spf1 include:_spf.google.com ~all"]
  ttl     = 3600
}

resource "aws_route53_record" "google-workspace-redirect" {
  count   = length(var.google-workspace-domain-cnames)
  zone_id = aws_route53_zone.main.zone_id
  name    = element(var.google-workspace-domain-cnames, count.index)
  type    = "CNAME"
  records = ["ghs.googlehosted.com"]
  ttl     = "3600"

}

resource "aws_route53_record" "google-workspace-dkim" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "google._domainkey"
  type    = "TXT"
  records = [
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuBmkxFlQ88PaGUtIL+EIxIjzYQhwm+bZdSsg3rkLNcNMdK9k4O3W3Mc7esPnJMwAJfT69nRPqoxdf9Ue4ZcKQ+RCAn2m8ZkTNVW80PeYcS0SXcEegOOC/2/O4fdaxTqE9B7KKNDLBkIXYI00pctQmQD3/GoZcIRYtldCZynP3/iTDAoSzOMfvvEWPCCxAktrN",
    "TgmxvK1tzM4LQv/mHkjeMr+Er2tmb3o068dgFzDLvc1hx4I4r3YWeejcoOeAHGLVj5elTEVMRGhXaxFClm+bbv52p2rDn3T5+apR60m2s/YOOdhNcfOxtC7vruFrogLYD5/Gsw9axEj05RwJb8MZQIDAQAB"
  ]
  ttl = 3600
}

resource "aws_route53_record" "github-challenge-mukvoting" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_github-challenge-mukvoting-org"
  type    = "TXT"
  ttl     = 3600
  records = ["fc368a3d88"]
}

resource "aws_route53_record" "github-pages-whatshark" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_github-pages-challenge-whatshark"
  type    = "TXT"
  ttl     = 3600
  records = ["73f6c2e828fd4ad858453addec73af"]
}