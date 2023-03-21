module "cluster_autoscaler" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.13"

  role_name                         = "${var.eks_cluster_name}-cluster-autoscaler-role"
  cluster_autoscaler_cluster_ids    = [var.eks_cluster_name]
  attach_cluster_autoscaler_policy  = true
  tags                              = var.tags

  oidc_providers                    = {
    main                            = {
      provider_arn                  = var.oidc_provider_arn
      namespace_service_accounts    = var.namespace_service_accounts
    }
  }
}
