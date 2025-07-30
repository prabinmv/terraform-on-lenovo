# Terraform AWS Application Load Balancer (ALB)
module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  #version = "5.16.0"
  version = "9.12.0"

  name = "${local.name}-nlb"
  load_balancer_type = "network"
  vpc_id = module.vpc.vpc_id
  dns_record_client_routing_policy = "availability_zone_affinity"
  subnets = module.vpc.public_subnets
  security_groups = [module.loadbalancer_sg.security_group_id]

  # For example only
  enable_deletion_protection = false

# Listeners
  listeners = {
    my-tcp = {
      port     = 80
      protocol = "TCP"
      forward = {
        target_group_key = "mytg1"
      }
    }

    my-tls = {
      port     = 443
      protocol = "TLS"
      certificate_arn = module.acm.acm_certificate_arn
      forward = {
        target_group_key = "mytg1"
      }
    }
  }

# Target Groups
  target_groups = {
  # Target Group-1: mytg1
   mytg1 = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false, refer above GitHub issue URL.
      ## Github ISSUE: https://github.com/terraform-aws-modules/terraform-aws-alb/issues/316
      ## Search for "create_attachment" to jump to that Github issue solution
      create_attachment = false
      name_prefix                       = "mytg1-"
      protocol                          = "TCP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }# End of Health Check Block
      tags = local.common_tags # Target Group Tags 
    } # END of Target Group-1: mytg1

  } # END OF target_groups
  tags = local.common_tags # ALB Tags
}# End of alb module

