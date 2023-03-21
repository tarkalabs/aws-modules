resource "aws_autoscaling_group_tag" "example" {
  for_each                = toset(var.asg_names)
  autoscaling_group_name  = each.value

  tag {
    key                   = var.tag_name
    value                 = var.tag_value
    propagate_at_launch   = var.propagate_at_launch
  }
}
