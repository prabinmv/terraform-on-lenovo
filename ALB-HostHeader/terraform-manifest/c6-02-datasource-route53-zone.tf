data "aws_route53_zone" "mydoamin" {
  name         = "cloud9aws.in"
#   private_zone = true
}

output "mydomain_zoneid" {
  description = "The hosted zone id"
  value = data.aws_route53_zone.mydoamin.zone_id
}
