include "root" {
  path         = find_in_parent_folders()
}

dependency "eks_cluster" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    cluster_name = "eks_cluster_name"
  }
}

dependency "lb_role" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/alb_ingress/role"
  mock_outputs = {
    role_arn   = "role_arn"
  }
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/helm_release"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  name                = "aws-load-balancer-controller"
  repository          = "https://aws.github.io/eks-charts"
  chart               = "aws-load-balancer-controller"
  chart_version       = "~> 1.4"
  namespace           = "kube-system"
  wait                = true
  settings            = [
    {
      name     = "clusterName"
      value    = dependency.eks_cluster.outputs.cluster_name
    },
    {
      name     = "ingressClass"
      value    = "shared-alb"
    },
    {
      name     = "ingressClassConfig.default"
      value    = true
    }
  ]
  values             = [
<<EOF
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${dependency.lb_role.outputs.role_arn}
EOF
  ]
}
