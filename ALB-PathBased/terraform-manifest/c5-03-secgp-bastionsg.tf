module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name = "public-bastion_sg"
  description = "Security group ssh port open for all"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp"]
  egress_rules = ["all-all"]
  tags = local.common_tags
}