include "root" {
  path         = find_in_parent_folders()
}

dependency "eks_cluster" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    cluster_name = "eks_cluster_name"
  }
}

dependency "istio_base" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/istio/istio_base"
  skip_outputs = true
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/helm_release"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  name                = "istiod"
  repository          = "https://istio-release.storage.googleapis.com/charts"
  chart               = "istiod"
  chart_version       = "~> 1.17"
  namespace           = "istio-system"
  wait                = true
}
