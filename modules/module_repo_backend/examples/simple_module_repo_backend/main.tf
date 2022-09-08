provider "aws" {
  region = "us-west-1"
}

data "aws_availability_zones" "available" {}

locals {
  vpc_cidr_block = "10.0.0.0/16"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "exafunction-vpc-simple"
  cidr = local.vpc_cidr_block
  azs  = data.aws_availability_zones.available.names
  private_subnets = [
    cidrsubnet(local.vpc_cidr_block, 4, 1),
    cidrsubnet(local.vpc_cidr_block, 4, 2),
    cidrsubnet(local.vpc_cidr_block, 4, 3),
  ]
  public_subnets = [
    cidrsubnet(local.vpc_cidr_block, 4, 4),
    cidrsubnet(local.vpc_cidr_block, 4, 5),
    cidrsubnet(local.vpc_cidr_block, 4, 6),
  ]
  database_subnets = [
    cidrsubnet(local.vpc_cidr_block, 4, 7),
    cidrsubnet(local.vpc_cidr_block, 4, 8),
    cidrsubnet(local.vpc_cidr_block, 4, 9),
  ]
}

resource "aws_security_group" "test_security_group" {
  name   = "test_security_group"
  vpc_id = module.vpc.vpc_id
}

module "exafunction_module_repo_backend" {
  source = "../../"

  exadeploy_id = "exafunction-mrbe-simple"

  db_storage             = 15
  postgres_version       = "13.4"
  db_username            = "test_user"
  db_port                = 5432
  db_instance_class      = "db.t4g.micro"
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.test_security_group.id]
}
