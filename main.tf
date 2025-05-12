terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Comentamos temporalmente el backend S3
  # backend "s3" {
  #   bucket = "nequi-terraform-state"
  #   key    = "state/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source = "./modules/iam"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port

  depends_on = [module.vpc]
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  source = "./modules/rds"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.public_subnets
  ecs_security_group_id = module.iam.ecs_security_group_id
  db_username           = var.db_username
  db_password           = var.db_password
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn     = module.iam.ecs_task_role_arn

  depends_on = [module.vpc, module.iam]
}

module "ecs" {
  source = "./modules/ecs"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  public_subnets        = module.vpc.public_subnets
  container_port        = var.container_port
  container_cpu         = var.container_cpu
  container_memory      = var.container_memory
  desired_count         = var.desired_count
  ecr_repository_url    = module.ecr.repository_url
  health_check_path     = var.health_check_path
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn     = module.iam.ecs_task_role_arn
  ecs_security_group_id = module.iam.ecs_security_group_id
  db_secret_arn         = module.rds.secret_arn

  depends_on = [module.vpc, module.ecr, module.iam, module.rds]
}

module "api_gateway" {
  source = "./modules/api_gateway"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  alb_listener_arn = module.ecs.alb_listener_arn

  depends_on = [module.ecs]
} 