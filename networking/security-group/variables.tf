variable "name" {
  description = "Name of the security group"
  type        = string
  default     = "terragrunt-poc-sg"
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Terragrunt poc security group"
}

variable "vpc_id" {
  description = "vpc id to use for the security group"
  type        = string
  default     = ""
}

variable "security_group_rules" {
  description = "List of allowed ports with cidr_blocks"
  type        = any
  default     = {}
  # {
  #   ingress_all_ssh = {
  #     protocol = "tcp"
  #     from_port = 22
  #     to_port = 22
  #     cidr_blocks = ["10.0.0.0/16", "10.10.0.0/16"]
  #   }
  # }
}

variable "tags" {
  type        = map(string)
}
