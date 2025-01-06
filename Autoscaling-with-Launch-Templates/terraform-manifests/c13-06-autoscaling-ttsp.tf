resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_50" {
  name                   = "avg-cpu-policy-greater-than-5"
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  estimated_instance_warmup = 180
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}


