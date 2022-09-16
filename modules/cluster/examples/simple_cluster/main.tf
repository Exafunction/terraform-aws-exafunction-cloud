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
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "exafunction_cluster" {
  source = "../../"

  cluster_name    = "exafunction-cluster-simple"
  cluster_version = "1.22"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  runner_pools = [{
    suffix                 = "cpu"
    node_instance_category = "cpu"
    capacity_type          = "SPOT"
    node_instance_type     = "m5.xlarge"
    disk_size              = 100
    min_size               = 1
    max_size               = 2
    accelerator_label      = ""
    additional_taints = [{
      key    = "test-taint"
      value  = "exafunction-taint-cpu"
      effect = "NO_SCHEDULE"
    }]
    additional_labels = {
      "test-label" = "exafunction-label-cpu"
    }
    }, {
    suffix                 = "gpu"
    node_instance_category = "gpu"
    capacity_type          = "ON_DEMAND"
    node_instance_type     = "g4dn.xlarge"
    disk_size              = 100
    min_size               = 0
    max_size               = 3
    accelerator_label      = "nvidia-tesla-t4"
    additional_taints = [{
      key    = "test-taint"
      value  = "exafunction-taint-gpu"
      effect = "NO_SCHEDULE"
    }]
    additional_labels = {
      "test-label" = "exafunction-label-gpu"
    }
  }]

  additional_node_groups = {
    "secondary" = {
      name           = "secondary"
      instance_types = ["m5.large"]
      disk_size      = 100
      desired_size   = 1
      min_size       = 1
      max_size       = 4
    }
  }

  instance_tags = {
    "owner" = "exafunction"
  }

  autoscaling_group_tags = {
    "owner" = "exafunction"
  }
}
