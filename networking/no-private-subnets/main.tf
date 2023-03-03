module "network" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs             = var.availability_zones
  private_subnets = []
  public_subnets  = var.public_subnets_cidr

  tags = merge({CreatedBy = "terragrunt"}, var.tags)
}
