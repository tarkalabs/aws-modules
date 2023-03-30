output "role_arn" {
  description = "IAM role ARN of the created resource"
  value       = module.aws_lb_controller.iam_role_arn
}
