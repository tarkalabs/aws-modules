module "cloudfront" {
  source   = "terraform-aws-modules/cloudfront/aws"
  version  = "~> 3.2"

  aliases             = var.aliases

  comment             = var.comment
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment
  default_root_object = var.default_root_object

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_main = "CloudFront access to s3 bucket ${var.s3_bucket_name}"
  }

  logging_config = var.logging_enabled ? var.logging_config : {}

  origin = {
    s3_bucket_main = {
      domain_name              = var.s3_bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.s3_sign.id
      origin_id                = "s3_bucket_main"
    }
  }

  default_cache_behavior = {
    path_pattern           = "*"
    target_origin_id       = "s3_bucket_main"
    viewer_protocol_policy = var.viewer_protocol_policy
    use_forwarded_values   = false
    cache_policy_id        = var.cache_policy_id
    allowed_methods        = ["GET", "HEAD"]
    compress               = true
  }
}

resource "aws_cloudfront_origin_access_control" "s3_sign" {
  name                              = "s3_sign_always"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "cloudfront_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers  = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
    resources = [
      "${var.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront_dist_access" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.cloudfront_policy.json
}
