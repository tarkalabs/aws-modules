include "root" {
  path         = find_in_parent_folders()
}

locals {
  tgvars       = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    eks_cluster_name = "eks_cluster_name"
  }
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/external_dns_irsa_role"
}

inputs         = {
  eks_cluster_name            = dependency.eks_cluster.outputs.cluster_name
  oidc_provider_arn           = dependency.eks_cluster.outputs.oidc_provider_arn
  fetch_hosted_zones          = true
  hosted_zone_details         = [{ "name" = local.tgvars.domain_name, "private" = false}]
}
