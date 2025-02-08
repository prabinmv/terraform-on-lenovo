module "bastion-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name                = "vprofile-elb"
  description         = "Security group for bastion host"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
  tags = {
    Name    = "Vprofile-bean-elb"
    Project = "Vprofile"
  }
}
