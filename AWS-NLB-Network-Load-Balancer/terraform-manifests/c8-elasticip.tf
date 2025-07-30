resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  instance                  = module.ec2_public.id
  depends_on                = [module.ec2_public, module.vpc]
  tags = local.common_tags
}