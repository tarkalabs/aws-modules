data "aws_route53_zone" "selected" {
  count        = var.fetch_hosted_zones ? length(var.hosted_zone_details) : 0
  name         = lookup(var.hosted_zone_details[count.index], "name", null)
  zone_id      = lookup(var.hosted_zone_details[count.index], "zone_id", null)
  private_zone = lookup(var.hosted_zone_details[count.index], "private_zone", false)
}

module "external_dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.13"

  role_name                      = "${var.eks_cluster_name}-external-dns-role"
  external_dns_hosted_zone_arns  = var.fetch_hosted_zones ? data.aws_route53_zone.selected.*.arn : var.hosted_zone_arns
  attach_external_dns_policy     = true
  tags                           = var.tags

  oidc_providers                 = {
    main                         = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = var.namespace_service_accounts
    }
  }
}
