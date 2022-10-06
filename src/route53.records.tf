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

resource "aws_route53_record" "calendar" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "calendar"
  type    = "CNAME"
  ttl     = 3600
  records = ["ghs.googlehosted.com"]
}

resource "aws_route53_record" "drive" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "drive"
  type    = "CNAME"
  ttl     = 3600
  records = ["ghs.googlehosted.com"]
}

resource "aws_route53_record" "gmail" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "gmail"
  type    = "CNAME"
  ttl     = 3600
  records = ["ghs.googlehosted.com"]
}

resource "aws_route53_record" "groups" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "groups"
  type    = "CNAME"
  ttl     = 3600
  records = ["ghs.googlehosted.com"]
}

resource "aws_route53_record" "sites" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "sites"
  type    = "CNAME"
  ttl     = 3600
  records = ["ghs.googlehosted.com"]
}