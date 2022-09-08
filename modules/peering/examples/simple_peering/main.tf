provider "aws" {
  region = "us-west-1"
}

data "aws_availability_zones" "available" {}

locals {
  exafunction_vpc_cidr_block = "10.255.0.0/16"
  peer_vpc_cidr_block        = "10.0.0.0/16"
}

module "exafunction_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "exafunction-vpc-simple"
  cidr = local.exafunction_vpc_cidr_block
  azs  = data.aws_availability_zones.available.names
  private_subnets = [
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 1),
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 2),
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 3),
  ]
  public_subnets = [
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 4),
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 5),
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 6),
  ]
  database_subnets = [
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 7),
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 8),
    cidrsubnet(local.exafunction_vpc_cidr_block, 4, 9),
  ]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "peer_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "peer-vpc-simple"
  cidr = local.peer_vpc_cidr_block
  azs  = data.aws_availability_zones.available.names
  private_subnets = [
    cidrsubnet(local.peer_vpc_cidr_block, 4, 1),
    cidrsubnet(local.peer_vpc_cidr_block, 4, 2),
    cidrsubnet(local.peer_vpc_cidr_block, 4, 3),
  ]
  public_subnets = [
    cidrsubnet(local.peer_vpc_cidr_block, 4, 4),
    cidrsubnet(local.peer_vpc_cidr_block, 4, 5),
    cidrsubnet(local.peer_vpc_cidr_block, 4, 6),
  ]
  database_subnets = [
    cidrsubnet(local.peer_vpc_cidr_block, 4, 7),
    cidrsubnet(local.peer_vpc_cidr_block, 4, 8),
    cidrsubnet(local.peer_vpc_cidr_block, 4, 9),
  ]
}

resource "aws_security_group" "fake_cluster_primary_security_group" {
  name   = "test_security_group"
  vpc_id = module.exafunction_vpc.vpc_id
}

module "exafunction_peering" {
  source               = "../.."
  vpc_id               = module.exafunction_vpc.vpc_id
  route_table_ids      = module.exafunction_vpc.private_route_table_ids
  security_group_id    = aws_security_group.fake_cluster_primary_security_group.id
  peer_vpc_id          = module.peer_vpc.vpc_id
  peer_route_table_ids = module.peer_vpc.private_route_table_ids
}
