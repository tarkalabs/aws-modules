output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = module.postgres_db.enhanced_monitoring_iam_role_name
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = module.postgres_db.enhanced_monitoring_iam_role_arn
}

output "address" {
  description = "The address of the RDS instance"
  value       = module.postgres_db.db_instance_address
}

output "arn" {
  description = "The ARN of the RDS instance"
  value       = module.postgres_db.db_instance_arn
}

output "availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.postgres_db.db_instance_availability_zone
}

output "endpoint" {
  description = "The connection endpoint in address:port format."
  value       = module.postgres_db.db_instance_endpoint
}

output "endpoint_url" {
  description = "The connection endpoint in address:port format."
  value       = "postgresql://${module.postgres_db.db_instance_username}:${module.postgres_db.db_instance_password}@${module.postgres_db.db_instance_endpoint}/${module.postgres_db.db_instance_name}"
  sensitive   = true
}

output "engine" {
  description = "The database engine"
  value       = module.postgres_db.db_instance_engine
}

output "engine_version_actual" {
  description = "The running version of the database"
  value       = module.postgres_db.db_instance_engine_version_actual
}

output "hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.postgres_db.db_instance_hosted_zone_id
}

output "id" {
  description = "The RDS instance ID"
  value       = module.postgres_db.db_instance_id
}

output "resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.postgres_db.db_instance_resource_id
}

output "status" {
  description = "The RDS instance status"
  value       = module.postgres_db.db_instance_status
}

output "db_name" {
  description = "The database name"
  value       = module.postgres_db.db_instance_name
}

output "username" {
  description = "The master username for the database"
  value       = module.postgres_db.db_instance_username
  sensitive   = true
}

output "password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.postgres_db.db_instance_password
  sensitive   = true
}

output "domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = module.postgres_db.db_instance_domain
}

output "domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service. "
  value       = module.postgres_db.db_instance_domain_iam_role_name
}

output "port" {
  description = "The database port"
  value       = module.postgres_db.db_instance_port
}

output "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = module.postgres_db.db_instance_ca_cert_identifier
}

output "subnet_group_id" {
  description = "The db subnet group name"
  value       = module.postgres_db.db_subnet_group_id
}

output "subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.postgres_db.db_subnet_group_arn
}

output "parameter_group_id" {
  description = "The db parameter group id"
  value       = module.postgres_db.db_parameter_group_id
}

output "parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.postgres_db.db_parameter_group_arn
}

# DB option group
output "option_group_id" {
  description = "The db option group id"
  value       = module.postgres_db.db_option_group_id
}

output "option_group_arn" {
  description = "The ARN of the db option group"
  value       = module.postgres_db.db_option_group_arn
}

################################################################################
# CloudWatch Log Group
################################################################################

output "cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.postgres_db.db_instance_cloudwatch_log_groups
}
