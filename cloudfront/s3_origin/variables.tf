variable "comment" {
  description = "Any comments you want to include about the distribution."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "S3 bucket name to configure access"
  type        = string
  default     = null
}

variable "s3_bucket_arn" {
  description = "S3 bucket arn to configure access"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  type        = bool
  default     = false
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process."
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  type        = string
  default     = null
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = "PriceClass_All"
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type    = list(string)
  default = null # ["cdn.example.com", "cdn.tarkalabs.com"]
}

variable "logging_enabled" {
  description = "Enable logging to s3 bucket for cloudfront traffic"
  type        = bool
  default     = false
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)."
  type        = map(string)
  default     = {
    bucket          = "terragrunt-poc"
    prefix           = "demo/"
    include_cookies = false
  }
}

variable "s3_bucket_regional_domain_name" {
  type        = string
}

variable "viewer_protocol_policy" {
  type        = string
  default     = "redirect-to-https"
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default     = null
  # {
  #   acm_certificate_arn       = ""
  #   minimum_protocol_version = "TLSv1"
  #   ssl_support_method       = "sni-only"
  # }
}

variable "acm_certificate_arn" {
  description = "Aws acm certificate ARN to use for cloudfront distribution"
  type        = string
  default     = null
}

variable "ssl_minimum_protocol_version" {
  description = "SSL minimum protocol version to use for cloudfront distribution"
  type        = string
  default     = "TLSv1"
}

variable "cache_policy_id" {
  type        = string
  default     = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
  # https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-1#/policies/cache
}
