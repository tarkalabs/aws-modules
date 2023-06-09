module "network" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 3.19"

  name            = var.vpc_name
  cidr            = var.vpc_cidr_block
  azs             = var.availability_zones
  private_subnets = []
  public_subnets  = var.public_subnets_cidr
  tags            = var.tags

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}
