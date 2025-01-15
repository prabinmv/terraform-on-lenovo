resource "aws_autoscaling_group" "my_asg" {
  name                      = "myasg"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns = [module.alb.target_groups["mytg1"].arn]
  # target_group_arns = []
  launch_template {
    id = aws_launch_template.my_launch_template.id
    version = aws_launch_template.my_launch_template.latest_version 
  }
  # instance_refresh {
  #   strategy = "Rolling"
  #   preferences {
  #     min_healthy_percentage = 50
  #   }
  #   triggers = ["desired_capacity"]
  # }
  tag {
    key                 = "Owners"
    value               = "Web-Team"
    propagate_at_launch = true
  }
}