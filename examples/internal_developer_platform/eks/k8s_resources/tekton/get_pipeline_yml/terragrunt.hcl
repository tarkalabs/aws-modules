include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
}

terraform {
  source      = "${get_path_to_repo_root()}//http_request"
}

inputs        = {
  url         = "https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.46.0/release.yaml"
}
