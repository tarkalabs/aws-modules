include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    cluster_name = "eks_cluster_name"
  }
}

terraform {
  source      = "${get_path_to_repo_root()}//eks/cluster_autoscaler_irsa_role"
}

inputs        = {
  eks_cluster_name            = dependency.eks_cluster.outputs.cluster_name
  oidc_provider_arn           = dependency.eks_cluster.outputs.oidc_provider_arn
  namespace_service_accounts  = ["kube-system:cluster-autoscaler"]
}
