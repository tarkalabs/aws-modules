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

variable "ingress_ports_and_cidr_blocks" {
  description = "List of allowed ports with cidr_blocks"
  type        = list(map(string))
  default     = []
  # {
  #   protocol = "tcp"
  #   from_port = 22
  #   to_port = 22
  #   cidr_blocks = "10.0.0.0/16,10.10.0.0/16"
  # }
}

variable "egress_ports_and_cidr_blocks" {
  description = "List of allowed ports with cidr_blocks"
  type        = list(map(string))
  default     = []
  # {
  #   protocol = "tcp"
  #   from_port = 22
  #   to_port = 22
  #   cidr_blocks = "10.0.0.0/16,10.10.0.0/16"
  # }
}

variable "tags" {
  type        = map(string)
}
