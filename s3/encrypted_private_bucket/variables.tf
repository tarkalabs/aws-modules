variable "name" {
  type     = string
  default  = "terragrunt-poc"
}

variable "sse_algorithm" {
  type     = string
  default  = "aws:kms"
}

variable "tags" {
  type     = map(string)
}
