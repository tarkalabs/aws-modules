include "root" {
  path        = find_in_parent_folders()
}

dependency "networking" {
  config_path  = "${get_parent_terragrunt_dir()}/networking/core"
}

dependency "ssh_key_pair" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/ssh_key_pair"
}

dependency "ssh_sg" {
  config_path  = "${get_parent_terragrunt_dir()}/eks/sg_ssh_eks"
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//eks/cluster"
}

inputs = {
  cluster_name    = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-eks"
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
    aws-ebs-csi-driver  = { most_recent = true }
  }

  eks_managed_node_group_defaults   = {
    # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
    # so we need to disable it to use the default template provided by the AWS EKS managed node group service
    use_custom_launch_template      = false
    use_name_prefix                  = false
    launch_template_use_name_prefix  = false
    iam_role_use_name_prefix         = false
    iam_role_attach_cni_policy      = true
    enable_bootstrap_user_data      = true
    ami_type                        = local.tgvars.default_eks_instance_ami_type
    instance_types                  = local.tgvars.default_eks_instance_types
    vpc_security_group_ids          = [dependency.ssh_sg.outputs.security_group_id]
    remote_access                   = {
      ec2_ssh_key                   = dependency.ssh_key_pair.outputs.name
      source_security_group_ids     = [dependency.ssh_sg.outputs.security_group_id]
    }
  }
  eks_managed_node_groups           = {
    platform_devops_ng              = {
      name                          = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-platform-devops-ng"
      iam_role_name                 = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-platform-devops-ng-role"

      ebs_optimized                 = true
      disk_size                     = local.tgvars.platform_devops_ng_disk_size

      labels                        = {
        layer = "platform"
      }

      min_size                      = 0
      max_size                      = 2
      desired_size                  = 1
    }
    app_deploy_ng                   = {
      name                          = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-app-deploy-ng-spot"
      iam_role_name                 = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-app-deploy-ng-role"

      capacity_type                 = local.tgvars.app_deploy_ng_capacity_type
      ebs_optimized                 = true
      disk_size                     = local.tgvars.app_deploy_ng_disk_size

      taints                        = local.tgvars.app_deploy_ng_taints
      labels                        = {
        layer = "apps_deployment"
      }

      update_config = {
        max_unavailable_percentage = 10
      }

      min_size                      = 0
      max_size                      = 2
      desired_size                  = 1
    }
  }
}
