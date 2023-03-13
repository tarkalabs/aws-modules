variable "secret_id" {
  description = "Friendly name of the new secret"
  type        = string
}

variable "secrets" {
  description = "Pass all secrets as a map"
  type     = map(string)
  default = {}
  # {
    # SECRET_1 = "top_secret_value"
  # }
}
