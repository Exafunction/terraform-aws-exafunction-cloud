data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.vpc_name
  cidr = var.vpc_cidr_block
  azs  = data.aws_availability_zones.available.names
  private_subnets = [
    cidrsubnet(var.vpc_cidr_block, 4, 1),
    cidrsubnet(var.vpc_cidr_block, 4, 2),
    cidrsubnet(var.vpc_cidr_block, 4, 3),
  ]
  public_subnets = [
    cidrsubnet(var.vpc_cidr_block, 4, 4),
    cidrsubnet(var.vpc_cidr_block, 4, 5),
    cidrsubnet(var.vpc_cidr_block, 4, 6),
  ]
  database_subnets = [
    cidrsubnet(var.vpc_cidr_block, 4, 7),
    cidrsubnet(var.vpc_cidr_block, 4, 8),
    cidrsubnet(var.vpc_cidr_block, 4, 9),
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
