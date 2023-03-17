module "key_pair" {
  source      = "terraform-aws-modules/key-pair/aws"
  version     = "~> 2.0"

  key_name              = var.key_name
  key_name_prefix        = var.key_name_prefix
  public_key            = var.public_key
  create_private_key    = var.create_private_key
  private_key_algorithm = var.private_key_algorithm
  private_key_rsa_bits  = var.private_key_rsa_bits
  tags                  = var.tags
}
