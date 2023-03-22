resource "aws_eip" "nat_gateway" {
  vpc = true
}

module "network" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 3.19"

  name            = var.vpc_name
  tags            = var.tags
  cidr            = var.vpc_cidr_block
  azs             = var.availability_zones
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  default_vpc_enable_dns_support    = true
  default_vpc_enable_dns_hostnames  = true

  enable_s3_endpoint     = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  single_nat_gateway     = true
  reuse_nat_ips          = true
  external_nat_ip_ids    = [aws_eip.nat_gateway.id]
}
