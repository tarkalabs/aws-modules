include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
}

dependency "cluster_autoscaler_role" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/k8s_resources/cluster_autoscaler/role"
}

terraform {
  source      = "${get_path_to_repo_root()}//eks/helm_release"
}

inputs        = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  name                = "app-layer-scaler"
  repository          = "https://kubernetes.github.io/autoscaler"
  chart               = "cluster-autoscaler"
  chart_version       = "~> 9.26"
  namespace           = "kube-system"

  values              = [
<<EOF

rbac:
  serviceAccount:
    name: app-layer-cluster-autoscaler
    annotations:
      eks.amazonaws.com/role-arn: ${dependency.cluster_autoscaler_role.outputs.role_arn}
EOF
  ]

  settings            = [
    {
      name    = "autoDiscovery.clusterName"
      value   = dependency.eks_cluster.outputs.cluster_name
    },
    {
      name    = "autoscalingGroups[0].name"
      value   = dependency.eks_cluster.outputs.managed_node_groups.app-deploy-ng.node_group_autoscaling_group_names.0
    },
    {
      name    = "autoscalingGroups[0].maxSize"
      value   = local.tgvars.app_deploy_ng_auto_scaling_max_size
    },
    {
      name    = "autoscalingGroups[0].minSize"
      value   = local.tgvars.app_deploy_ng_auto_scaling_min_size
    }
  ]
}
