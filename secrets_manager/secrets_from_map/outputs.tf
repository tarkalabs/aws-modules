output "arns" {
  description = "ARN of the generated aws secret"
  value       = values(aws_secretsmanager_secret_version.main).*.arn
}

output "ids" {
  description = "A pipe delimited combination of secret ID and version ID for all secrets created"
  value       = values(aws_secretsmanager_secret_version.main).*.id
}

output "version_ids" {
  description = "The unique identifier of the version of the secret for all secrets created"
  value       = values(aws_secretsmanager_secret_version.main).*.version_id
}
