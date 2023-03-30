module "aws_lb_controller" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.13"

  attach_load_balancer_controller_policy     = true

  role_name                      = "${var.eks_cluster_name}-aws-lb-controller-role"
  tags                           = var.tags

  oidc_providers                 = {
    main                         = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = var.namespace_service_accounts
    }
  }
}
