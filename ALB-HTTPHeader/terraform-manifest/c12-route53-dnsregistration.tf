resource "aws_route53_record" "default_dns" {
  zone_id = data.aws_route53_zone.mydoamin.zone_id
  name    = "myapps.cloud9aws.in"
  type    = "A"
  # ttl     = 300
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app1_dns" {
  zone_id = data.aws_route53_zone.mydoamin.zone_id
  name    = "azure-aks11.cloud9aws.in"
  type    = "A"
  # ttl     = 300
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "app2_dns" {
#   zone_id = data.aws_route53_zone.mydoamin.zone_id
#   name    = var.app2_dns_name
#   type    = "A"
#   # ttl     = 300
#   alias {
#     name                   = module.alb.dns_name
#     zone_id                = module.alb.zone_id
#     evaluate_target_health = true
#   }
# }