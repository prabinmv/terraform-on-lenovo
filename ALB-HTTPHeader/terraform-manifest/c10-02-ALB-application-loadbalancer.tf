module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.12.0"

  enable_deletion_protection = false

  name    = "${local.name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.loadbalancer_sg.security_group_id]
  tags = local.common_tags

  #listerner

  listeners = {
    my-http-https-redirect = {
      port        = 80
      protocol    = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    my-https_listeners = {
      port               = 443
      protocol           = "HTTPS"
      ssl_policy         = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn    = module.acm.acm_certificate_arn
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed message"
        status_code  = "200"
      }

      rules = {
        myapp1-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg1"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = true
              duration = 3600
            }
          }]

          conditions = [{
             http_header = {
              http_header_name = "custom-header"
              values           = ["app-1", "app1", "my-app-1"]
            }
          }]
        } # End of app1 rule

        myapp2-rule = {
          priority = 2
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "mytg2"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = true
              duration = 3600
            }
          }]

          conditions = [{
            http_header = {
              http_header_name = "custom-header"
              values           = ["app-2", "app2", "my-app-2"]
            }
          }]
        } # End of app2 rule


        my-redirect-query = {
          priority = 3
          actions = [{
            type        = "redirect"
            status_code = "HTTP_302"
            host        = "stacksimplify.com"
            path        = "/aws-eks/"
            query       = ""
            protocol    = "HTTPS"
          }]

          conditions = [{
            query_string = [{
              key   = "website"
              value = "aws-eks"
              }]
          }]
        }

        my-redirect-header = {
          priority = 4
          actions = [{
            type        = "redirect"
            status_code = "HTTP_302"
            host        = "stacksimplify.com"
            path        = "/azure-aks/azure-kubernetes-service-introduction/"
            query       = ""
            protocol    = "HTTPS"
          }]

          conditions = [{
            host_header = {
              values = ["azure-aks11.cloud9aws.in"]
            }
          }]
        }

      }
   }
  }

  # Target Gtoup
  target_groups = {
    mytg1 = {
      create_attachment = false
      name_prefix                       = "mytg1-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
    #   target_id        = aws_instance.this.id
      port             = 80
      tags = local.common_tags
    } // TG1

    mytg2 = {
      create_attachment = false
      name_prefix                       = "mytg2-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
    #   target_id        = aws_instance.this.id
      port             = 80
      tags = local.common_tags
    } // TG2
  }
}

resource "aws_lb_target_group_attachment" "mytg1" {
  for_each = {for k, v in module.ec2_private_app1: k => v}
  target_group_arn = module.alb.target_groups["mytg1"].arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "mytg2" {
  for_each = {for k, v in module.ec2_private_app2: k => v}
  target_group_arn = module.alb.target_groups["mytg2"].arn
  target_id        = each.value.id
  port             = 80
}

# output "zz_ec2_private" {
#   value = {for ec2_instance, details in  module.ec2_private: ec2_instance => details}
# }