provider "aws" {
  # profile = var.aws_profile
  # region  = "us-west-2"
}

module "terraform_aws_ssm" {
  source = "./modules/terraform-aws-ssm"
}

module "terraform_aws_image_repo" {
  source = "./modules/terraform-aws-image-repo"
}

module "terraform_aws_network" {
  source = "./modules/terraform-aws-network"
}

module "terraform_aws_ecs_agent" {
  source = "./modules/terraform-aws-ecs-agent"
  license_key_arn = module.terraform_aws_ssm.license_key_arn
}

module "terraform_aws_database" {
  source = "./modules/terraform-aws-database"
  db_password = var.db_password
  database_subnets_ids = module.terraform_aws_network.public_subnets_ids
  database_vpc_id = module.terraform_aws_network.vpc_id
}

module "terraform_aws_loadbalancer" {
  source = "./modules/terraform-aws-loadbalancer"
  vpc_id = module.terraform_aws_network.vpc_id
  subnets_ids = module.terraform_aws_network.public_subnets_ids
}

module "terraform_aws_lite_poll_service" {
  source = "./modules/terraform-aws-service"
  vpc_id = module.terraform_aws_network.vpc_id
  iam_instance_profile_name = module.terraform_aws_ecs_agent.role_name
  image_repo_url = module.terraform_aws_image_repo.url
  subnets_ids = module.terraform_aws_network.public_subnets_ids
  service_target_group_arn = module.terraform_aws_loadbalancer.target_group_arn
  loadbalancer_security_group_id = module.terraform_aws_loadbalancer.loadbalancer_security_group_id
  role_arn = module.terraform_aws_ecs_agent.role_arn
  db_config = {
    user = module.terraform_aws_database.username
    password = var.db_password
    host = module.terraform_aws_database.hostname
    port = module.terraform_aws_database.port
  }
  new_relic_config = var.new_relic_config
}
