resource "aws_route53_record" "github-challenge-mukvoting" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_github-challenge-mukvoting-org"
  type    = "TXT"
  ttl     = 3600
  records = ["fc368a3d88"]
}

resource "aws_route53_record" "keybase" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "whatshark.com"
  type    = "TXT"
  ttl     = 3600
  records = ["keybase-site-verification=0-xAbh86MC_fqONGB5gStg6Z59JChhATmwgNEC4VS6"]
}

resource "aws_route53_record" "github-pages-whatshark" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_github-pages-challenge-whatshark"
  type    = "TXT"
  ttl     = 3600
  records = ["73f6c2e828fd4ad858453addec73af"]
}

resource "aws_route53_record" "google-workspace-redirect" {
  count   = length(var.google-workspace-domain-cnames)
  zone_id = aws_route53_zone.main.zone_id
  name    = element(var.google-workspace-domain-cnames, count.index)
  type    = "CNAME"
  records = ["ghs.googlehosted.com"]
  ttl     = "3600"

}

resource "aws_route53_record" "google-workspace" {
  zone_id = aws_route53_zone.main.zone_id
  name    = ""
  type    = "MX"
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com",
  ]
  ttl = 3600
}