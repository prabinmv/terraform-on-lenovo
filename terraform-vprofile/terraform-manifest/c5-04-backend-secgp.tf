module "vprofile-basckend-secgp" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "vprofile-backend"
  description = "Security group for backend"
  vpc_id      = module.vpc.vpc_id
  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Service name"
      source_security_group_id = module.vprofile-bean-instance-secgp.security_group_id
    },
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "Service name"
      source_security_group_id = module.bastion-sg.security_group_id
    },
    {
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Service name"
      source_security_group_id = module.vprofile-basckend-secgp.security_group_id
    }
  ]
  egress_rules = ["all-all"]
  tags = {
    Name    = "Vprofile-bean-elb"
    Project = "Vprofile"
  }
}