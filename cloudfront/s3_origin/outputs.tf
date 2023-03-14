output "id" {
  description = "The identifier for the distribution."
  value       = module.cloudfront.cloudfront_distribution_id
}

output "arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = module.cloudfront.cloudfront_distribution_arn
}

output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = module.cloudfront.cloudfront_distribution_caller_reference
}

output "status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = module.cloudfront.cloudfront_distribution_status
}

output "trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = module.cloudfront.cloudfront_distribution_trusted_signers
}

output "domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = module.cloudfront.cloudfront_distribution_last_modified_time
}

output "in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = module.cloudfront.cloudfront_distribution_in_progress_validation_batches
}

output "etag" {
  description = "The current version of the distribution's information."
  value       = module.cloudfront.cloudfront_distribution_etag
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = module.cloudfront.cloudfront_distribution_hosted_zone_id
}

output "origin_access_identities" {
  description = "The origin access identities created"
  value       = module.cloudfront.cloudfront_origin_access_identities
}

output "origin_access_identity_ids" {
  description = "The IDS of the origin access identities created"
  value       = module.cloudfront.cloudfront_origin_access_identity_ids
}

output "origin_access_identity_iam_arns" {
  description = "The IAM arns of the origin access identities created"
  value       = module.cloudfront.cloudfront_origin_access_identity_iam_arns
}
