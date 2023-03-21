output "role_arn" {
  description = "IAM role ARN of the created resource"
  value       = module.external_dns.iam_role_arn
}
