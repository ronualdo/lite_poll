provider "aws" {
  profile = var.aws_profile
  region  = "us-west-2"
}

module "terraform_aws_image_repo" {
  source = "./modules/terraform-aws-image-repo"
}

module "terraform_aws_network" {
  source = "./modules/terraform-aws-network"
}

module "terraform_aws_ecs_agent" {
  source = "./modules/terraform-aws-ecs-agent"
}

module "terraform_aws_database" {
  source = "./modules/terraform-aws-database"
  db_password = var.db_password
  database_subnets_ids = module.terraform_aws_network.public_subnets_ids
  database_vpc_id = module.terraform_aws_network.vpc_id
}

module "terraform_aws_lite_poll_service" {
  source = "./modules/terraform-aws-service"
  vpc_id = module.terraform_aws_network.vpc_id
  iam_instance_profile_name = module.terraform_aws_ecs_agent.role_name
  image_repo_url = module.terraform_aws_image_repo.url
  subnets_ids = module.terraform_aws_network.public_subnets_ids
  service_target_group_arn = module.terraform_aws_loadbalancer.target_group_arn
  db_host = module.terraform_aws_database.hostname
  db_port = module.terraform_aws_database.port
  db_user = module.terraform_aws_database.username
  db_password = var.db_password
}

 
module "terraform_aws_loadbalancer" {
  source = "./modules/terraform-aws-loadbalancer"
  vpc_id = module.terraform_aws_network.vpc_id
  subnets_ids = module.terraform_aws_network.public_subnets_ids
}
# 
# module "terraform_aws_service" {
#   source = "./modules/terraform-aws-service"
#   security_group_ids = module.terraform_aws_network.service_security_group_ids
#   vpc_zone_identifiers = module.terraform_aws_network.service_vpc_zone_identifiers
#   scaling_group_arns = [module.terraform_aws_loadbalancer.target_group_arn]
#   service_target_group_arn = module.terraform_aws_loadbalancer.target_group_arn
# } 
