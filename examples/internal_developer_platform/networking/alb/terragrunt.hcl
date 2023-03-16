include "root" {
  path        = find_in_parent_folders()
}

dependency "networking" {
  config_path  = "${get_parent_terragrunt_dir()}/networking/core"
}

dependency "lb_sg" {
  config_path  = "${get_parent_terragrunt_dir()}/networking/sg_alb"
}

dependency "acm" {
  config_path = "${get_parent_terragrunt_dir()}/acm_certificate"
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//load_balancer/alb"
}

inputs = {
  name        = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-public-lb"
  tags        = local.tgvars.tags

  load_balancer_type         = "application"
  internal                   = false
  enable_http2               = true
  preserve_host_header       = true

  vpc_id                     = dependency.networking.outputs.vpc_id
  subnets                    = dependency.networking.outputs.public_subnet_ids
  security_groups            = [dependency.lb_sg.outputs.security_group_id]

  http_tcp_listeners         = [
    {
      port           = 80
      protocol       = "HTTP"
      action_type    = "redirect"
      redirect       = {
        port         = "443"
        protocol     = "HTTPS"
        status_code  = "HTTP_301"
      }
    }
  ]
  https_listeners            = [
    {
      port                   = 443
      protocol               = "HTTPS"
      action_type            = "fixed-response"
      certificate_arn         = dependency.acm.outputs.certificate_arn
      fixed_response          = {
        content_type         = "application/json"
        message_body         = "{message: \"Route Not Implemented\"}"
        status_code          = "501"
      }
    }
  ]
  enable_cross_zone_load_balancing  = true
}
