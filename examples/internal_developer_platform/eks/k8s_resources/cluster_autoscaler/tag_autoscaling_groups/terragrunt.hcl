include "root" {
  path        = find_in_parent_folders()
}

dependency "eks_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/cluster"
  mock_outputs = {
    cluster_name = "eks_cluster_name"
  }
}

terraform {
  source      = "${get_path_to_repo_root()}//autoscaling/update_asg_tags"
}

inputs        = {
  asg_names   = [
    dependency.eks_cluster.outputs.managed_node_groups.platform-devops-ng.node_group_autoscaling_group_names.0,
    dependency.eks_cluster.outputs.managed_node_groups.app-deploy-ng.node_group_autoscaling_group_names.0
  ]
  tags        = {
    "k8s.io/cluster-autoscaler/enabled"      = "true"
    "k8s.io/cluster-autoscaler/prod-idp-eks" = ""
  }
}
