include "root" {
  path         = find_in_parent_folders()
}

dependency "networking" {
  config_path   = "${get_parent_terragrunt_dir()}/networking/core"
  mock_outputs = {
    vpc_id              = "vpc_id"
    private_subnet_ids  = []
  }
}

dependency "ssh_key_pair" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/ssh_key_pair"
  mock_outputs = {
    name       = "name"
  }
}

dependency "ssh_sg" {
  config_path   = "${get_parent_terragrunt_dir()}/eks/sg_ssh_eks"
  mock_outputs = {
    security_group_id   = "security_group_id"
  }
}

locals {
  tgvars       = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source       = "${get_path_to_repo_root()}//eks/cluster"
}

inputs         = {
  cluster_name    = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-eks-cluster"
  cluster_version = local.tgvars.cluster_version
  tags            = local.tgvars.tags

  vpc_id          = dependency.networking.outputs.vpc_id
  subnet_ids      = dependency.networking.outputs.private_subnet_ids

  cluster_endpoint_public_access    = true

  create_kms_key                    = true
  kms_key_administrators_usernames  = local.tgvars.kms_key_administrators

  create_cloudwatch_log_group            = true
  cloudwatch_log_group_retention_in_days = local.tgvars.cluster_logs_retention

  cluster_addons  = {
    coredns             = { most_recent = true }
    kube-proxy          = { most_recent = true }
  }

  eks_managed_node_group_defaults   = {
    # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
    # so we need to disable it to use the default template provided by the AWS EKS managed node group service
    use_custom_launch_template      = false
    launch_template_use_name_prefix  = true
    iam_role_use_name_prefix         = true
    iam_role_attach_cni_policy      = true
    enable_bootstrap_user_data      = true
    ebs_optimized                   = true
    ami_type                        = local.tgvars.default_eks_instance_ami_type
    remote_access                   = {
      ec2_ssh_key                   = dependency.ssh_key_pair.outputs.name
      source_security_group_ids     = [dependency.ssh_sg.outputs.security_group_id]
    }
    update_config                    = {
      max_unavailable_percentage    = 10
    }
    private_dns_name_options        = {
      hostname_type                 = "ip-name"
    }
  }
  eks_managed_node_groups           = {
    platform-devops-ng              = {
      name_prefix                    = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-platform-devops-ng"
      iam_role_name                 = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-platform-devops-ng-role"

      labels                        = { layer = "platform" }

      disk_size                     = local.tgvars.platform_devops_ng_disk_size
      capacity_type                 = local.tgvars.platform_devops_ng_capacity_type
      instance_types                = local.tgvars.platform_devops_ng_instance_types

      desired_size                  = local.tgvars.platform_devops_ng_desired_size
      min_size                      = local.tgvars.platform_devops_ng_auto_scaling_min_size
      max_size                      = local.tgvars.platform_devops_ng_auto_scaling_max_size
    }
    app-deploy-ng                   = {
      name_prefix                    = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-app-deploy-ng"
      iam_role_name                 = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-app-deploy-ng-role"

      labels                        = { layer = "app" }
      taints                        = local.tgvars.app_deploy_ng_taints

      disk_size                     = local.tgvars.app_deploy_ng_disk_size
      capacity_type                 = local.tgvars.app_deploy_ng_capacity_type
      instance_types                = local.tgvars.app_deployment_ng_instance_types

      desired_size                  = local.tgvars.app_deploy_ng_desired_size
      min_size                      = local.tgvars.app_deploy_ng_auto_scaling_min_size
      max_size                      = local.tgvars.app_deploy_ng_auto_scaling_max_size
    }
  }
}
