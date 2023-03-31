include "root" {
  path         = find_in_parent_folders()
}

locals {
  tgvars       = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "networking" {
  config_path   = "${get_parent_terragrunt_dir()}/networking/core"
  mock_outputs = {
    private_subnet_ids  = []
  }
}

dependency "acm_cert" {
  config_path = "${get_parent_terragrunt_dir()}/acm_certificate"
}

dependency "eks_cluster" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    cluster_name = "eks_cluster_name"
  }
}

dependency "setup" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/alb_ingress/setup"
  skip_outputs = true
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/independent_yaml_manifests"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  yaml_content        = templatefile("${get_original_terragrunt_dir()}/ingress.yml.tftpl", {
    cluster_name      = replace(lower(dependency.eks_cluster.outputs.cluster_name), "_", "-")
    public_subnets    = join(", ", dependency.networking.outputs.public_subnet_ids)
    acm_cert_arn      = dependency.acm_cert.outputs.certificate_arn
  })
}
