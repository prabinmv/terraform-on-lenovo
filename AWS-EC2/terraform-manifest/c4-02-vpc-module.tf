module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"
  
  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs                 = var.vpc_availability_zones
  private_subnets     = var.vpc_private_subnets
  public_subnets      = var.vpc_public_subnets

  create_database_subnet_group = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  database_subnets    = var.vpc_database_subnets

  private_subnet_names = ["Private Subnet One", "Private Subnet Two"]
  public_subnet_names = ["Public Subnet One", "Public Subnet Two"]
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway =  var.vpc_single_nat_gateway
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Type = "Public-subnet"
  }

  private_subnet_tags = {
    Type = "Private-subnet"
  }

  database_subnet_tags = {
    Type = "database-subnet"
  }
  tags = local.common_tags
  vpc_tags = {
    Name = "VPC-DEV"
  }
}

