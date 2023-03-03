resource "aws_cloudwatch_log_group" "ecs_cluster_log" {
  name              = "/aws/ecs/${var.cluster_name}"
  retention_in_days = var.logs_retention_period

  tags = var.tags
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights_enabled ? "enabled" : "disabled"
  }

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster_log.name
      }
    }
  }

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    weight            = 100
    capacity_provider = var.default_capacity_provider
  }
}
