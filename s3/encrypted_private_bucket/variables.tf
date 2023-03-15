variable "name" {
  type     = string
  default  = "terragrunt-poc"
}

variable "sse_algorithm" {
  type     = string
  default  = "AES256"
}

variable "tags" {
  type     = map(string)
}
