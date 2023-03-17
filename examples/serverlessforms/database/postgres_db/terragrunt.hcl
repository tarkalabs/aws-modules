include "root" {
  path        = find_in_parent_folders()
}

dependency "networking" {
  config_path  = "${get_parent_terragrunt_dir()}/networking/core"
}

dependency "db_sg" {
  config_path  = "${get_parent_terragrunt_dir()}/database/sg_postgres_db"
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//rds/postgres"
}

inputs        = {
  identifier   = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-db"
  tags        = local.tgvars.tags

  engine               = "postgres"
  engine_version       = "14.6"
  instance_class       = "db.t3.micro"
  storage_type         = "gp3"
  allocated_storage    = 25
  multi_az             = false
  publicly_accessible  = false
  db_name              = local.tgvars.app_name
  username             = "${local.tgvars.app_name}"

  create_cloudwatch_log_group    = true
  deletion_protection            = false
  skip_final_snapshot             = false
  copy_tags_to_snapshot          = true

  vpc_security_group_ids         = [dependency.db_sg.outputs.security_group_id]

  subnet_ids                     = dependency.networking.outputs.public_subnet_ids
  create_db_subnet_group         = true
  db_subnet_group_name           = "${local.tgvars.env_prefix}-${local.tgvars.app_name}"
  db_subnet_group_use_name_prefix = false

  family                         = "postgres14"
  create_db_parameter_group      = true
  parameter_group_name           = "${local.tgvars.env_prefix}-${local.tgvars.app_name}"
  parameter_group_use_name_prefix = false

  major_engine_version           = "14"
  create_db_option_group         = true
  option_group_name              = "${local.tgvars.env_prefix}-${local.tgvars.app_name}"
  option_group_use_name_prefix    = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-postgres-rds-monitoring-role"
  monitoring_role_use_name_prefix        = false
}
