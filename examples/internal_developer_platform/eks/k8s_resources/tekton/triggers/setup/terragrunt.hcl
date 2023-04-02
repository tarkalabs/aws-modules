include "root" {
  path         = find_in_parent_folders()
}

locals {
  tgvars       = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    eks_cluster_name  = "eks_cluster_name"
  }
}

dependency "pipelines_setup" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/tekton/pipelines/setup"
  skip_outputs = true
}

dependency "setup_yml" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/tekton/triggers/get_setup_yml"
  mock_outputs = {
    response_body     = "response_body"
  }
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/manifests_local_exec"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  yaml_content        = dependency.setup_yml.outputs.response_body
  namespace           = "tekton-pipelines"
}
