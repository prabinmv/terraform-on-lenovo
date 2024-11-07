module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name = "private-sg"
  description = "Security group ssh port open for all"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = module.vpc.vpc_cidr_block
  ingress_rules = ["ssh-tcp", "https-443-tcp"]
  egress_rules = ["all-all"]
  tags = local.common_tags
}