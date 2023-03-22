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

dependency "git_clone" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/tekton/hub_tasks/git_clone"
  mock_outputs = {
    response_body     = "response_body"
  }
}

dependency "k8s_actions" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/k8s_resources/tekton/hub_tasks/kubernetes_actions"
  mock_outputs = {
    response_body     = "response_body"
  }
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/manifests_local_exec"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  yaml_content        = join("\n---\n", [dependency.git_clone.outputs.response_body, dependency.k8s_actions.outputs.response_body])
}
