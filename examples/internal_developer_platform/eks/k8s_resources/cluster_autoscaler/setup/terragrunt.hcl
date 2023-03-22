include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
}

dependency "ca_role" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/k8s_resources/cluster_autoscaler/role"
}

terraform {
  source      = "${get_path_to_repo_root()}//eks/helm_release"
}

inputs        = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  name                = "cluster-autoscaler"
  repository          = "https://kubernetes.github.io/autoscaler"
  chart               = "cluster-autoscaler"
  chart_version       = "~> 9.26"
  namespace           = "kube-system"

  settings            = [
    {
      name    = "autoDiscovery.clusterName"
      value   = dependency.eks_cluster.outputs.cluster_name
    }
  ]

  values              = [
<<EOF
fullnameOverride: cluster-autoscaler
extraArgs:
  expander: least-waste
  balance-similar-node-groups: true
  skip-nodes-with-local-storage: false
  skip-nodes-with-system-pods: false # please set below flag to true for production clusters
rbac:
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: ${dependency.ca_role.outputs.role_arn}
autoscalingGroups:
  - name: ${dependency.eks_cluster.outputs.managed_node_groups.platform-devops-ng.node_group_autoscaling_group_names.0}
    maxSize: ${local.tgvars.platform_devops_ng_auto_scaling_max_size}
    minSize: ${local.tgvars.platform_devops_ng_auto_scaling_min_size}
  - name: ${dependency.eks_cluster.outputs.managed_node_groups.app-deploy-ng.node_group_autoscaling_group_names.0}
    maxSize: ${local.tgvars.app_deploy_ng_auto_scaling_max_size}
    minSize: ${local.tgvars.app_deploy_ng_auto_scaling_min_size}
EOF
  ]
}
