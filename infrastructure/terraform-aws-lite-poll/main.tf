provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "terraform_aws_network" {
  source = "./modules/terraform-aws-network"
}

module "terraform_aws_database" {
  source = "./modules/terraform-aws-database"
  db_password = var.db_password
  database_subnets = module.terraform_aws_network.database_subnets_ids
  security_group_ids = module.terraform_aws_network.database_security_group_ids
}

module "terraform_aws_loadbalancer" {
  source = "./modules/terraform-aws-loadbalancer"
  vpc_id = module.terraform_aws_network.loadbalancer_vpc_id
  security_groups = module.terraform_aws_network.loadbalancer_security_group_ids
  subnets = module.terraform_aws_network.loadbalancer_subnet_ids
}

module "terraform_aws_service" {
  source = "./modules/terraform-aws-service"
  security_group_ids = module.terraform_aws_network.service_security_group_ids
  vpc_zone_identifiers = module.terraform_aws_network.service_vpc_zone_identifiers
  scaling_group_arns = [module.terraform_aws_loadbalancer.target_group_arn]
  service_target_group_arn = module.terraform_aws_loadbalancer.target_group_arn
} 
