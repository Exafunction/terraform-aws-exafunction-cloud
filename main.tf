provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  exafunction_vpc_cidr_block = "10.255.0.0/16"
  peer_vpc_cidr_block        = "10.0.0.0/16"
}

module "exafunction_network" {
  source = "./modules/network"

  vpc_name       = "exafunction-vpc-${var.suffix}"
  vpc_cidr_block = local.exafunction_vpc_cidr_block
}

module "exafunction_cluster" {
  source = "./modules/cluster"

  cluster_name    = "exafunction-cluster-${var.suffix}"
  cluster_version = "1.22"

  vpc_id     = module.exafunction_network.vpc_id
  subnet_ids = module.exafunction_network.private_subnets

  runner_pools = [{
    suffix                 = "cpu"
    node_instance_category = "cpu"
    capacity_type          = "SPOT"
    node_instance_type     = "m5.xlarge"
    disk_size              = 100
    min_size               = 1
    max_size               = 4
    accelerator_label      = ""
    additional_taints      = []
    additional_labels      = {}
    }, {
    suffix                 = "gpu"
    node_instance_category = "gpu"
    capacity_type          = "ON_DEMAND"
    node_instance_type     = "g4dn.xlarge"
    disk_size              = 100
    min_size               = 0
    max_size               = 3
    accelerator_label      = "nvidia-tesla-t4"
    additional_taints      = []
    additional_labels      = {}
  }]
}

module "exafunction_module_repo_backend" {
  source = "./modules/module_repo_backend"

  exadeploy_id = "exafunction-mrbe-${var.suffix}"

  db_storage           = 15
  postgres_version     = "13.4"
  db_username          = "exafunction"
  db_port              = 5432
  db_instance_class    = "db.t4g.micro"
  db_subnet_group_name = module.exafunction_network.database_subnet_group_name
  vpc_security_group_ids = [
    module.exafunction_cluster.cluster_primary_security_group_id,
    module.exafunction_cluster.cluster_security_group_id,
    module.exafunction_cluster.node_security_group_id,
  ]
}

module "peer_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "peer-vpc-${var.suffix}"
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
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "exafunction_peering" {
  source = "./modules/peering"

  vpc_id               = module.exafunction_network.vpc_id
  route_table_ids      = module.exafunction_network.private_route_table_ids
  security_group_id    = module.exafunction_cluster.node_security_group_id
  peer_vpc_id          = module.peer_vpc.vpc_id
  peer_route_table_ids = module.peer_vpc.private_route_table_ids
}
