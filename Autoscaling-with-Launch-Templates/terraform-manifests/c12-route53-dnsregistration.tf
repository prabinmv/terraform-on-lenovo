resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.mydoamin.zone_id
  name    = "asg-it.kloudoc8s.in"
  type    = "A"
  # ttl     = 300
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}