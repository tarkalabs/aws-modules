output "vpc_id" {
  value   = module.network.vpc_id
}

output "public_subnet_ids" {
  value   = module.network.public_subnets
}

output "vpc_cidr_block" {
  value   = module.network.vpc_cidr_block
}
