module "acm" {
  source       = "terraform-aws-modules/acm/aws"
  version      = "~> 4.3"

  domain_name  = local.domain_name
  zone_id      = data.aws_route53_zone.this.zone_id
  tags         = var.tags
  dns_ttl      = var.dns_ttl

  validation_method         = var.validation_method
  subject_alternative_names = var.subject_alternative_names
  wait_for_validation       = var.wait_for_validation
}

locals {
  # Removing trailing dot from domain - just to be sure :)
  domain_name  = trimsuffix(var.domain_name, ".")
}

data "aws_route53_zone" "this" {
  name         = local.domain_name
  private_zone = false
}
