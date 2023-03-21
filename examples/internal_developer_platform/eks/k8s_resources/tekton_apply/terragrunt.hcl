include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
}

dependency "tekton_pipeline_yaml" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/k8s_resources/tekton_pipeline_yml"
}

terraform {
  source      = "${get_path_to_repo_root()}//eks/manifests_local_exec"
}

inputs        = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  yaml_content        = dependency.tekton_pipeline_yaml.outputs.response_body
}
