terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "terraform_aws_vpc" {
  source = "./modules/terraform-aws-vpc"
}

module "terraform_aws_database" {
  source = "./modules/terraform-aws-database"
  db_password = var.db_password
  public_subnets = module.terraform_aws_vpc.vpc_public_subnets
  vpc_id = module.terraform_aws_vpc.vpc_id
}
