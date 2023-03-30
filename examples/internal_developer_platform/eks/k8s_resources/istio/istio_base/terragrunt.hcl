include "root" {
  path         = find_in_parent_folders()
}

dependency "eks_cluster" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    cluster_name = "eks_cluster_name"
  }
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/helm_release"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  name                = "istio-base"
  repository          = "https://istio-release.storage.googleapis.com/charts"
  chart               = "base"
  chart_version       = "~> 1.17"
  namespace           = "istio-system"
  create_namespace    = true
  wait                = true
}
