module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.12.0"

  enable_deletion_protection = false

  name    = "${local.name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = module.loadbalancer_sg.security_group_id
  tags = local.common_tags
}