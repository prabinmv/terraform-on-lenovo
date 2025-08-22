resource "aws_autoscaling_policy" "high-cpu" {
  name                   = "high-cpu"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

resource "aws_cloudwatch_metric_alarm" "app1_asg_cwa_cpu" {
  alarm_name                = "App1-ASG-CWA-CPUUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_asg.name
  }
  ok_actions = [aws_sns_topic.myasg_sns_topic.arn]
  alarm_actions     = [
    aws_autoscaling_policy.high-cpu.arn,
    aws_sns_topic.myasg_sns_topic.arn
  ]
}