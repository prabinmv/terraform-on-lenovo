module "vprofile-bean-elb-secgp" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name                = "vprofile-elb"
  description         = "Security group for beanstalk elb"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_rules        = ["all-all"]
  tags = {
    Name    = "Vprofile-bean-elb"
    Project = "Vprofile"
  }
}

module "vprofile-bean-instance-secgp" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "vprofile-elb-instance-secgp"
  description = "Security group for beanstalk instance secgp"
  vpc_id      = module.vpc.vpc_id
  # ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Service name"
      source_security_group_id = module.vprofile-bean-elb-secgp.security_group_id
  }]
  egress_rules = ["all-all"]
  tags = {
    Name    = "Vprofile-bean-elb"
    Project = "Vprofile"
  }
}