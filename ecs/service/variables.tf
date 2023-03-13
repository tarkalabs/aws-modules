# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
# variables for ecs service
variable "name" {
  description = "Name of the ECS service"
  type        = string
  default     = "terragrunt-poc-service"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "terragrunt-poc-cluster"
}

variable "compatibilities" {
  description = "Task definition compatibilities"
  type        = list(string)
  default     = ["FARGATE"] # Should be one of "EC2", "FARGATE", "EXTERNAL"
}

variable "launch_type" {
  description = "Service launch type"
  type        = string
  default     = "EC2"
}

variable "scheduling_strategy" {
  description = "Service scheduing strategy"
  type        = string
  default     = "REPLICA"
}

variable "desired_count" {
  description = "Number of tasks to run for the service"
  type        = number
  default     = 1
}

variable "deploy_min_healthy_percent" {
  description = "Lower limit as a percentage of the service's desiredCount that must remain running and healthy in a service during a deployment."
  type        = number
  default     = 100
}

variable "deploy_max_percent" {
  description = "Upper limit as a percentage of the service's desiredCount that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "subnet_ids" {
  description = "Subnet ids to use for the service"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security groups to assign for the service"
  type        = list(string)
  default     = []
}

variable "assign_public_ip" {
  description = "Enable public ip for the ECS service"
  type        = bool
  default     = false
}

variable "enable_load_balancer" {
  description = "Enable load balancer for the ECS service"
  type        = bool
  default     = false
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "Load balancer configuration for the service"
  type        = list(string)
  # "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/terragrunt-poc-target-group/1234567890123456"
  default     = []
}

variable "placement_strategy" {
  description = "Placement strategy for the service"
  type        = list(map(string))
  default     = [
    {
      type    = "spread"
      field    = "attribute:ecs.availability-zone"
    },
    {
      type    = "spread"
      field    = "instanceId"
    }
  ]
}

variable "placement_constraints" {
  description = "Placement constraints for the service"
  type        = list(map(string))
  default     = []
}

variable "tags" {
  type        = map(string)
}

variable "propagate_tags_from" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks"
  type        = string
  default     = "TASK_DEFINITION"
}

# variables for ecs task definition
variable "task_def_family_name" {
  description = "Name of the task definition family"
  type        = string
  default     = "terragrunt-poc"
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task"
  type        = string
  default     = "awsvpc"
}

variable "container_name" {
  description = "Name of the container within the task definition"
  type        = string
  default     = "nginx"
}

variable "container_image" {
  description = "Docker image to use for the container"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port to expose on the container"
  type        = number
  default     = 80
}

variable "container_cpu" {
  description = "CPU units to reserve for the container"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memory to reserve for the container"
  type        = number
  default     = 512
}

variable "task_role_arn" {
  description = "Role ARN to use for the task"
  type        = string
  default     = null
}

variable "task_exec_role_required" {
  description = "Task requires execution role?"
  type        = bool
  default     = false
}

variable "task_exec_role_name" {
  description = "Name to use for fetching role arn to include in the task execution"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "logging_config" {
  description = "Cloudwatch container logging config"
  type        = object({
    logDriver = string
    options   = optional(map(string), null)
    secretOptions = optional(list(map(string)), null)
  })
  default     = null
}
