module "asg_tags" {
  source    = "./asg_tag"
  for_each  = var.tags

  asg_names = var.asg_names
  tag_name  = each.key
  tag_value = each.value
  propagate_at_launch = var.propagate_at_launch
}
