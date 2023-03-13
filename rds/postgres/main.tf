module "postgres_db" {
  source       = "terraform-aws-modules/rds/aws"
  version      = "~> 5.6"

  identifier                      = var.identifier
  instance_use_identifier_prefix   = var.instance_use_identifier_prefix

  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  network_type          = var.network_type
  deletion_protection   = var.deletion_protection
  publicly_accessible   = var.publicly_accessible
  apply_immediately     = var.apply_immediately
  blue_green_update     = var.blue_green_update
  replicate_source_db   = var.replicate_source_db

  multi_az                 = var.multi_az
  availability_zone        = var.availability_zone
  vpc_security_group_ids   = var.vpc_security_group_ids

  storage_type          = var.storage_type
  storage_throughput    = var.storage_throughput
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  create_random_password              = var.create_random_password
  random_password_length              = var.random_password_length
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  allow_major_version_upgrade         = var.allow_major_version_upgrade
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade

  enabled_cloudwatch_logs_exports         = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group             = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days  = var.cloudwatch_log_group_retention_in_days

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = var.db_name
  username = var.username
  port     = var.port

  create_db_subnet_group         = var.create_db_subnet_group
  db_subnet_group_name           = var.db_subnet_group_name
  db_subnet_group_use_name_prefix = var.db_subnet_group_use_name_prefix
  db_subnet_group_description    = var.db_subnet_group_description
  subnet_ids                     = var.subnet_ids

  family                         = var.family
  create_db_parameter_group      = var.create_db_parameter_group
  parameter_group_name           = var.parameter_group_name
  parameter_group_use_name_prefix = var.parameter_group_use_name_prefix
  parameter_group_description    = var.parameter_group_description
  parameters                     = var.parameters

  major_engine_version           = var.major_engine_version
  create_db_option_group         = var.create_db_option_group
  option_group_name              = var.option_group_name
  option_group_use_name_prefix    = var.option_group_use_name_prefix
  option_group_description       = var.option_group_description
  options                        = var.options

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  delete_automated_backups        = var.delete_automated_backups
  backup_retention_period         = var.backup_retention_period

  skip_final_snapshot       = var.skip_final_snapshot
  snapshot_identifier       = var.snapshot_identifier
  copy_tags_to_snapshot    = var.copy_tags_to_snapshot

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_name                  = var.monitoring_role_name
  monitoring_role_use_name_prefix        = var.monitoring_role_use_name_prefix
  monitoring_role_description           = var.monitoring_role_description

  tags                    = var.tags
  db_option_group_tags    = merge(var.tags, var.db_option_group_tags)
  db_parameter_group_tags = merge(var.tags, var.db_parameter_group_tags)
  db_subnet_group_tags    = merge(var.tags, var.db_subnet_group_tags)
}
