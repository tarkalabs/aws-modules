variable "asg_names" {
  type          = list(string)
  description   = "Names of the Autoscaling Group to apply the tag to"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "propagate_at_launch" {
  type          = bool
  description   = "Whether to propagate the tags to instances launched by the ASG"
  default       = true
}
