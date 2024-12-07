module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name  = trimsuffix(data.aws_route53_zone.mydoamin.name, ".")
  zone_id      = data.aws_route53_zone.mydoamin.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.cloud9aws.in"
  ]

  wait_for_validation = true

  tags = {
    Name = local.common_tags
  }
}

output "acm_ceertoficate_arn" {
  description = "ARN of Certificate"
  value = module.acm.acm_certificate_arn
}