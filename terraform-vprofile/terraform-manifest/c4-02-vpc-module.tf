module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs                = var.vpc_availability_zones
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
  #   enable_vpn_gateway = true
  single_nat_gateway = var.vpc_single_nat_gateway
  tags               = local.common_tags

  enable_dns_hostnames = true
  enable_dns_support   = true

  vpc_tags = {
    Name = "VProfile"
  }
}