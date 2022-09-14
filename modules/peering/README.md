# Exafunction Peering Module
This Terraform module is used to set up peering between an Exafunction VPC and another VPC. It is responsible for creating a VPC peering connection, routing rules to route traffic destined for the other VPC to the peering connection, and a security group rule to allow ingress traffic from the peered VPC into the Exafunction VPC. In order for the peering setup to work, the VPCs' CIDR ranges must be disjoint and they can't be peered with other VPCs whose CIDR ranges overlap the newly peered VPC.

Note that this only adds a security group rule to the Exafunction VPC and not the peered VPC. This means that the peered VPC can initiate requests to the Exafunction VPC but the other direction is not allowed. Additionally, peering is generally recommended between VPCs in the same region to avoid costly cross-regional egress costs. This module does not currently support peering between VPCs in different AWS accounts.

## Usage
```hcl
module "exafunction_peering" {
  # Set the module source and version to use this module.
  source = "Exafunction/exafunction-cloud/aws//modules/peering"
  version = "0.1.0"

  # Set the VPC ID, route table IDs, and security group ID of the Exafunction VPC.
  vpc_id               = "vpc-abcd1234"
  route_table_ids      = ["rtb-abcd1234", "rtb-abcd5678"]
  security_group_id    = "sg-abcd1234"

  # Set the VPC ID and route table IDs of the peered VPC.
  peer_vpc_id          = "vpc-abcd5678"
  peer_route_table_ids = ["rtb-efab1234", "rtb-efab5678"]

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/peering/variables.tf) file for a full list of configuration options.

See [examples/simple_peering](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/peering/examples/simple_peering) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-aws-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_route.exafunction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group_rule.exafunction_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_peering_connection.exafunction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc.exafunction_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.peer_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_peer_route_table_ids"></a> [peer\_route\_table\_ids](#input\_peer\_route\_table\_ids) | List of route table IDs for the peer VPC to add routes to. | `list(string)` | n/a | yes |
| <a name="input_peer_vpc_id"></a> [peer\_vpc\_id](#input\_peer\_vpc\_id) | ID of the peer VPC. | `string` | n/a | yes |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | List of route table IDs in the Exafunction VPC to add routes to. | `list(string)` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | ID of the security group to allow ingress for. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the Exafunction VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_egress_route_ids"></a> [egress\_route\_ids](#output\_egress\_route\_ids) | ID of the egress (Exafunction VPC to peering connection) route. |
| <a name="output_ingress_route_ids"></a> [ingress\_route\_ids](#output\_ingress\_route\_ids) | IDs of the ingress (peer VPC to peering connection) routes. |
| <a name="output_ingress_security_group_rule_id"></a> [ingress\_security\_group\_rule\_id](#output\_ingress\_security\_group\_rule\_id) | ID of the security group rule allowing ingress from the peer VPC. |
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | ID of the VPC peering connection. |
<!-- END_TF_DOCS -->
