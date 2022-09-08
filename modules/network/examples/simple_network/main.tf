provider "aws" {
  region = "us-west-1"
}

module "exafunction_network" {
  source = "../../"

  vpc_name       = "exafunction-vpc-simple"
  vpc_cidr_block = "10.0.0.0/16"
}
