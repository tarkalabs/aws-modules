resource "aws_secretsmanager_secret" "main" {
  name                    = var.use_name_prefix ? null : var.name
  name_prefix              = var.use_name_prefix ? "${var.name}-" : null
  description             = coalesce(var.description, format("%s secret", var.name))
  kms_key_id              = var.kms_key_id
  tags                    = var.tags
  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = jsonencode(var.secrets)
}
