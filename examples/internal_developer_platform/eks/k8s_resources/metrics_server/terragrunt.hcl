include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
}

terraform {
  source      = "${get_path_to_repo_root()}//eks/helm_release"
}

inputs        = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  name                = "metrics-server"
  repository          = "https://kubernetes-sigs.github.io/metrics-server/"
  chart               = "metrics-server"
  chart_version       = "~> 3.8"
  namespace           = "kube-system"

  settings            = [
    {
      # If true, create the v1beta1.metrics.k8s.io API service. You typically want this enabled!
      # If you disable API service creation you have to manage it outside of this chart
      # for e.g horizontal pod autoscaling to work with this release.
      name    = "apiService.create"
      value   = "true"
    }
  ]
}
