include "root" {
  path         = find_in_parent_folders()
}

locals {
  tgvars       = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
  storage_classes_yaml  = file("${get_original_terragrunt_dir()}/manifests/storage_classes.yml")
  namespace_yaml        = templatefile("${get_original_terragrunt_dir()}/manifests/namespace.tftpl", {
    namespace  = local.tgvars.platform_namespace
  })
}

dependency "eks_cluster" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    eks_cluster_name  = "eks_cluster_name"
  }
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/independent_yaml_manifests"
}

inputs         = {
  eks_cluster_name    = dependency.eks_cluster.outputs.cluster_name
  yaml_content        = join("\n---\n", [local.namespace_yaml, local.storage_classes_yaml])
}
