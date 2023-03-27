data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "~> 19.10"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_ip_family              = var.cluster_ip_family

  tags                           = var.tags
  cluster_tags                   = var.cluster_tags

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  control_plane_subnet_ids       = coalescelist(var.control_plane_subnet_ids, var.subnet_ids)

  cluster_addons_timeouts        = var.cluster_addons_timeouts
  cluster_addons                 = merge(var.cluster_addons, {
    vpc-cni                      = {
      most_recent                = true
      before_compute             = true
      service_account_role_arn   = module.vpc_cni_irsa.iam_role_arn
      configuration_values        = jsonencode({
        env                      = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION    = "true"
          WARM_PREFIX_TARGET          = "1"
        }
      })
    }
    aws-ebs-csi-driver           = {
      most_recent                = true
      service_account_role_arn   = module.ebs_csi_irsa.iam_role_arn
    }
  })

  cluster_service_ipv4_cidr               = var.cluster_service_ipv4_cidr
  cluster_service_ipv6_cidr               = var.cluster_service_ipv6_cidr
  cluster_endpoint_public_access_cidrs    = var.cluster_endpoint_public_access_cidrs
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_additional_security_group_ids   = var.cluster_additional_security_group_ids

  create_kms_key                          = var.create_kms_key
  kms_key_description                     = var.kms_key_description
  kms_key_deletion_window_in_days         = var.kms_key_deletion_window_in_days
  enable_kms_key_rotation                 = var.enable_kms_key_rotation
  kms_key_enable_default_policy           = var.kms_key_enable_default_policy
  kms_key_aliases                         = var.kms_key_aliases
  kms_key_owners                          = setunion(var.kms_key_owners, values(data.aws_iam_user.kms_key_owners)[*].arn)
  kms_key_administrators                  = setunion(var.kms_key_administrators, values(data.aws_iam_user.kms_key_administrators)[*].arn)
  kms_key_users                           = setunion(var.kms_key_users, values(data.aws_iam_user.kms_key_users)[*].arn)
  kms_key_service_users                   = setunion(var.kms_key_service_users, values(data.aws_iam_user.kms_key_service_users)[*].arn)
  kms_key_source_policy_documents         = var.kms_key_source_policy_documents
  kms_key_override_policy_documents       = var.kms_key_override_policy_documents

  create_cloudwatch_log_group             = var.create_cloudwatch_log_group
  cluster_enabled_log_types               = var.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days  = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id         = var.cloudwatch_log_group_kms_key_id

  eks_managed_node_group_defaults         = var.eks_managed_node_group_defaults
  eks_managed_node_groups                 = var.eks_managed_node_groups

  create_aws_auth_configmap                = true
  manage_aws_auth_configmap                = true
  cluster_encryption_config                = var.cluster_encryption_config
  attach_cluster_encryption_policy        = var.attach_cluster_encryption_policy

  create_cluster_primary_security_group_tags  = var.create_cluster_primary_security_group_tags
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.13"

  role_name              = "${var.cluster_name}-vpc-cni-irsa-role"
  attach_vpc_cni_policy  = true
  vpc_cni_enable_ipv4    = true
  vpc_cni_enable_ipv6    = var.cluster_ip_family == "ipv6"
  tags                   = var.tags

  oidc_providers         = {
    main                 = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

module "ebs_csi_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.13"

  role_name              = "${var.cluster_name}-ebs-csi-irsa-role"
  attach_ebs_csi_policy  = true
  tags                   = var.tags

  oidc_providers         = {
    main                 = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

data "aws_iam_user" "kms_key_administrators" {
  for_each    = toset(var.kms_key_administrators_usernames)
  user_name   = each.key
}

data "aws_iam_user" "kms_key_owners" {
  for_each    = toset(var.kms_key_owners_usernames)
  user_name   = each.key
}

data "aws_iam_user" "kms_key_users" {
  for_each    = toset(var.kms_key_users_usernames)
  user_name   = each.key
}

data "aws_iam_user" "kms_key_service_users" {
  for_each    = toset(var.kms_key_service_users_usernames)
  user_name   = each.key
}
