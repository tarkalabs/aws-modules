resource "aws_ecs_task_definition" "main" {
  family         = var.task_def_family_name
  tags           = var.tags
  network_mode   = var.network_mode
  cpu            = "${var.container_cpu}"
  memory         = "${var.container_memory}"

  requires_compatibilities  = var.compatibilities
  task_role_arn             = var.task_role_arn
  # exec role is required when you want logs to push to cloudwatch / pull ecr image for fargate tasks
  execution_role_arn        = var.task_exec_role_required ? data.aws_iam_role.task_exec_role[0].arn : null
  container_definitions      = jsonencode([{
    essential    = true
    name         = "${var.container_name}"
    image        = "${var.container_image}"
    portMappings = [{
      containerPort = "${var.container_port}"
    }]
    logConfiguration = length(var.logging_config) > 0 ? var.logging_config : null
  }])
}

data "aws_iam_role" "task_exec_role" {
  count           = var.task_exec_role_required ? 1 : 0
  name            = var.task_exec_role_name
}

resource "aws_ecs_service" "main" {
  name            = var.name
  cluster         = var.cluster_name
  task_definition  = aws_ecs_task_definition.main.arn

  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deploy_min_healthy_percent
  deployment_maximum_percent         = var.deploy_max_percent

  launch_type             = var.launch_type
  scheduling_strategy     = var.scheduling_strategy

  enable_ecs_managed_tags = true
  propagate_tags          = var.propagate_tags_from
  tags                    = var.tags

  dynamic "ordered_placement_strategy" {
    for_each = { for strategy in var.placement_strategy : "${strategy.type}_${strategy.field}" => strategy }
    content {
      type  = ordered_placement_strategy.value.type
      field  = ordered_placement_strategy.value.field
    }
  }

  dynamic "placement_constraints" {
    for_each = { for constraint in var.placement_strategy : "${constraint.type}_${constraint.expression}" => constraint }
    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  dynamic "network_configuration" {
    for_each = [1]
    content {
      security_groups    = var.security_group_ids
      subnets            = var.subnet_ids
      assign_public_ip   = var.assign_public_ip
    }
  }

  deployment_circuit_breaker {
    enable    = true
    rollback  = true
  }

  health_check_grace_period_seconds = var.enable_load_balancer ? var.health_check_grace_period_seconds : null

  # Conditionally configure load balancer blocks with target group arns
  dynamic "load_balancer" {
    for_each  = var.enable_load_balancer && length(var.target_group_arns) != 0 ? var.target_group_arns : []
    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes     = [desired_count, task_definition]

    # precondition {
    #   condition     = var.enable_load_balancer && length(var.target_group_arns) == 0
    #   error_message = "When enable_load_balancer is true, target_group_arns must be a non-empty list"
    # }
  }
}
