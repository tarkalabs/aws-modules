output "id" {
  description = "ID of the generated aws secret"
  value       = aws_secretsmanager_secret.main.id
}

output "arn" {
  description = "ARN of the generated aws secret"
  value       = aws_secretsmanager_secret.main.arn
}

output "version_id" {
  description = "The unique identifier of the version of the secret"
  value       = aws_secretsmanager_secret_version.main.version_id
}
