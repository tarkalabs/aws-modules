output "vpc_id" {
  value   = module.network.vpc_id
}

output "vpc_name" {
  value   = module.network.name
}

output "vpc_cidr_block" {
  value   = module.network.vpc_cidr_block
}

output "azs" {
  value   = module.network.azs
}

output "natgw_ids" {
  value   = module.network.natgw_ids
}

output "nat_public_ips" {
  value   = module.network.nat_public_ips
}

output "public_subnets_cidr_blocks" {
  value   = module.network.public_subnets_cidr_blocks
}

output "public_subnet_ids" {
  value   = module.network.public_subnets
}

output "private_subnets_cidr_blocks" {
  value   = module.network.private_subnets_cidr_blocks
}

output "private_subnet_ids" {
  value   = module.network.private_subnets
}
