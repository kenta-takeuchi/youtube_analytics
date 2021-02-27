data "aws_route53_zone" "practice" {
  name = "youtubemoviesanalytics.link"
}

resource "aws_route53_record" "this" {
  name    = data.aws_route53_zone.practice.name
  type    = "A"
  zone_id = data.aws_route53_zone.practice.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}

output "domain_name" {
  value = aws_route53_record.this.name
}

