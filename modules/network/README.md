# Exafunction Network Module

This Terraform module is used to set up the required network resources for an ExaDeploy system. It is responsible for creating a VPC and subnets that the Exafunction EKS cluster will be deployed to. The VPC will use all avialability zones in the AWS provider's region and will create 9 subnets (3 public, 3 private, 3 database) each with 1/16th of the VPC's CIDR block (since each subnet uses uses 4 additional network prefix bits within the VPC's CIDR block).

Note that EKS clusters deployed in this VPC that want to deploy load balancers to a subnet require Kubernetes version >= 1.19 or must add tag `kubernetes.io/cluster/<cluster_name> = shared` to the desired subnets.

## Usage
```hcl
module "exafunction_network" {
  # Set the module source to use this module.
  source = "Exafunction/exafunction-cloud/aws//modules/network"

  # Set the name of the VPC and its CIDR block.
  vpc_name       = "exafunction-vpc-simple"
  vpc_cidr_block = "10.0.0.0/16"

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/network/variables.tf) file for a full list of configuration options.

See [examples/simple_network](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/network/examples/simple_network) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-aws-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block range for VPC to create. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of VPC to create. | `string` | `"exafunction-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | Availability zones of the created VPC. |
| <a name="output_database_route_table_ids"></a> [database\_route\_table\_ids](#output\_database\_route\_table\_ids) | List of route table IDs for database subnets in the created VPC. |
| <a name="output_database_subnet_arns"></a> [database\_subnet\_arns](#output\_database\_subnet\_arns) | List of ARNs of database subnets in the created VPC. |
| <a name="output_database_subnet_group"></a> [database\_subnet\_group](#output\_database\_subnet\_group) | ID of the database subnet group in the created VPC. |
| <a name="output_database_subnet_group_name"></a> [database\_subnet\_group\_name](#output\_database\_subnet\_group\_name) | Name of the database subnet group in the created VPC. |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets in the created VPC. |
| <a name="output_database_subnets_cidr_blocks"></a> [database\_subnets\_cidr\_blocks](#output\_database\_subnets\_cidr\_blocks) | List of CIDR blocks for database subnets in the created VPC. |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of route table IDs for private subnets in the created VPC. |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of private subnets in the created VPC. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets in the created VPC. |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of CIDR blocks for private subnets in the created VPC. |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of route table IDs for public subnets in the created VPC. |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of public subnets in the created VPC. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets in the created VPC. |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of CIDR blocks for public subnets in the created VPC. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | ARN of the created VPC. |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | CIDR block of the created VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the created VPC. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Name of the created VPC. |
<!-- END_TF_DOCS -->
