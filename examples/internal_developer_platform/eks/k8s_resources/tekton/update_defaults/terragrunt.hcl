include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
}

dependency "tekton_setup" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/k8s_resources/tekton/setup"
}

terraform {
  source      = "${get_path_to_repo_root()}//eks/independent_yaml_manifests"
}

inputs        = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  yaml_content        = file("${get_original_terragrunt_dir()}/tekton_default_config.yml")
}
