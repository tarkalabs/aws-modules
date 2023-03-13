output "id" {
  description = "ID of the generated aws secret"
  value       = aws_secretsmanager_secret.main.id
}

output "arn" {
  description = "ARN of the generated aws secret"
  value       = aws_secretsmanager_secret.main.arn
}

output "ids" {
  description = "A pipe delimited combination of secret ID and version ID for all secrets created"
  value       = module.secrets.ids
}

output "version_ids" {
  description = "The unique identifier of the version of the secret for all secrets created"
  value       = module.secrets.version_ids
}
