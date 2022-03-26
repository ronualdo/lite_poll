output "vpc_id" {
  description = "vpc id"
  value = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  description = "vpc subnets"
  value = module.vpc.public_subnets
}
