module "r53_records" {
  source       = "terraform-aws-modules/route53/aws//modules/records"
  version      = "~> 2.10"

  zone_name           = var.zone_name
  zone_id             = var.zone_id
  records             = var.records
  records_jsonencoded = var.records_jsonencoded
}
