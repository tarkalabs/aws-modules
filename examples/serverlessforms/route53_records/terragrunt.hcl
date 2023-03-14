include "root" {
  path        = find_in_parent_folders()
}

dependency "cloudfront" {
  config_path  = "${get_parent_terragrunt_dir()}/frontend/cloudfront"
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//route53/records"
}

inputs = {
  zone_name   = local.tgvars.domain_name
  records     = [
    {
      name        = ""
      type        = "A"
      alias       = {
        name      = dependency.cloudfront.outputs.domain_name
        zone_id   = dependency.cloudfront.outputs.hosted_zone_id
      }
    },
    {
      name        = "www"
      type        = "A"
      alias       = {
        name      = dependency.cloudfront.outputs.domain_name
        zone_id   = dependency.cloudfront.outputs.hosted_zone_id
      }
    }
  ]
}
