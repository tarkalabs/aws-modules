variable "asg_names" {
  type          = list(string)
  description   = "Names of the Autoscaling Group to apply the tag to"
}

variable "tag_name" {
  description   = "Tag name"
  type          = string
}

variable "tag_value" {
  description   = "Tag value"
  type          = string
}

variable "propagate_at_launch" {
  type          = bool
  description   = "Whether to propagate the tags to instances launched by the ASG"
  default       =  true
}
