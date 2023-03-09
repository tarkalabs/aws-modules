variable "cluster_name" {
  type      = string
  default   = "terragrunt"
}

variable "default_capacity_provider" {
  type      = string
  default   = "FARGATE_SPOT"
}

variable "logs_retention_period" {
  type      = number
  default   = "30"
}

variable "container_insights_enabled" {
  type      = bool
  default   = false
}

variable "tags" {
  type      = map(string)
}
