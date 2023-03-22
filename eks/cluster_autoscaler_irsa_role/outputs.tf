output "role_arn" {
  description = "IAM role ARN of the created resource"
  value       = module.cluster_autoscaler.iam_role_arn
}
