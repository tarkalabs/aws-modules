module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.4"

  name                   = var.name
  load_balancer_type     = var.load_balancer_type
  internal               = var.internal
  vpc_id                 = var.vpc_id
  subnets                = var.subnets
  security_groups        = var.security_groups
  access_logs            = var.access_logs
  idle_timeout           = var.idle_timeout
  ip_address_type        = var.ip_address_type
  tags                   = var.tags

  enable_http2              = var.enable_http2
  http_tcp_listeners        = var.http_tcp_listeners
  http_tcp_listener_rules   = var.http_tcp_listener_rules
  extra_ssl_certs           = var.extra_ssl_certs
  https_listeners           = var.https_listeners
  https_listener_rules      = var.https_listener_rules
  target_groups             = var.target_groups

  create_security_group             = var.create_security_group
  security_group_name               = var.security_group_name
  security_group_use_name_prefix     = var.security_group_use_name_prefix
  security_group_description        = var.security_group_description
  security_group_rules              = var.security_group_rules

  enable_waf_fail_open              = var.enable_waf_fail_open
  desync_mitigation_mode            = var.desync_mitigation_mode
  listener_ssl_policy_default       = var.listener_ssl_policy_default
  preserve_host_header              = var.preserve_host_header
  drop_invalid_header_fields         = var.drop_invalid_header_fields
  enable_deletion_protection        = var.enable_deletion_protection
  enable_cross_zone_load_balancing  = var.enable_cross_zone_load_balancing
}
