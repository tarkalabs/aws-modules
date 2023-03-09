variable "vpc_name" {
  type      = string
  default   = "main"
}

variable "vpc_cidr_block" {
  type      = string
  default   = "10.10.0.0/16"
}

variable "availability_zones" {
  type      = list(string)
  default   = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_cidr" {
  type      = list(string)
  default   = ["10.10.0.0/19", "10.10.32.0/19"]
}

variable "tags" {
  type      = map(string)
}
