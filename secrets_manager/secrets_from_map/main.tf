resource "aws_secretsmanager_secret_version" "main" {
  for_each      = var.secrets
  secret_id     = var.secret_id
  secret_string = "${each.key}=${each.value}"
}
