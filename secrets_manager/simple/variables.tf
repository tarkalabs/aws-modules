variable "name" {
  description = "Friendly name of the new secret"
  type        = string
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique identifier beginning with `name` as the specified prefix"
  type        = bool
  default     = false
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
  default     = null
}

variable "kms_key_id" {
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret"
  type        = string
  default     = null
}

variable "secrets" {
  description = "Pass all secrets as a map"
  type     = map(string)
  default = {}
  # {
    # SECRET_1 = "top_secret_value"
  # }
}

variable "tags" {
  type     = map(string)
}
