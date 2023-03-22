include "root" {
  path        = find_in_parent_folders()
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

dependency "external_dns_role" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/external_dns/role"
  mock_outputs = {
    role_arn   = "role_arn"
  }
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/helm_release"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  name                = "external-dns"
  repository          = "https://charts.bitnami.com/bitnami"
  chart               = "external-dns"
  chart_version       = "~> 6.14"
  namespace           = "kube-system"
  values              = [
<<EOF
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${dependency.external_dns_role.outputs.role_arn}
EOF
  ]
}
