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
  public_subnets = module.terraform_aws_network.database_public_subnets
  security_group_ids = module.terraform_aws_network.database_security_group_ids
}

module "terraform_aws_service" {
  source = "./modules/terraform-aws-service"
  security_group_ids = [module.terraform_aws_network.ecs_security_group_id]
  vpc_zone_identifiers = [module.terraform_aws_network.pub_subnet_id]
} 
