# Exafunction Cluster Module

This Terraform module is used to set up the required cluster resources for an ExaDeploy system. It is responsible for creating an EKS cluster that the ExaDeploy system will be deployed in, as well as node groups in that cluster and autoscaling group tags to enable cluster autoscaling for these node groups.

## Usage
```hcl
module "exafunction_cluster" {
  # Set the module source and version to use this module.
  source = "Exafunction/exafunction-cloud/aws//modules/cluster"
  version = "x.y.z"

  # Set the cluster name.
  cluster_name = "exafunction-cluster"

  # Set the VPC and subnets to deploy the cluster in.
  vpc_id     = "vpc-abcd1234"
  subnet_ids = ["subnet-abcd1234", "subnet-abcd5678"]

  # Configure the ExaDeploy runner pools.
  runner_pools = [{
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

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/cluster/variables.tf) file for a full list of configuration options.

See [examples/simple_cluster](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/cluster/examples/simple_cluster) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-aws-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group_tag.additional_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group_tag) | resource |
| [aws_autoscaling_group_tag.autoscaler_scale_to_zero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group_tag) | resource |
| [aws_security_group_rule.exafunction_ingress_in_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_node_groups"></a> [additional\_node\_groups](#input\_additional\_node\_groups) | Map of additional EKS managed node group definitions to create. For schema, see https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.29.0/modules/eks-managed-node-group/README.md#inputs. | `any` | `{}` | no |
| <a name="input_autoscaling_group_tags"></a> [autoscaling\_group\_tags](#input\_autoscaling\_group\_tags) | Tags to apply to all autoscaling groups managed by the cluster. These tags will not be propagated to the EC2 instances. | `map(string)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster to create. | `string` | `"exafunction-cluster"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes minor version to use for the EKS cluster (for example 1.22). | `string` | `"1.22"` | no |
| <a name="input_instance_tags"></a> [instance\_tags](#input\_instance\_tags) | Tags to apply to all EC2 instances managed by the cluster. | `map(string)` | `{}` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Number of days to retain EKS control plane logs. | `number` | `90` | no |
| <a name="input_runner_pools"></a> [runner\_pools](#input\_runner\_pools) | Configuration parameters for Exafunction runner node pools. | <pre>list(object({<br>    # Node group suffix.<br>    suffix = string<br>    # One of (cpu, gpu, inferentia).<br>    node_instance_category = string<br>    # One of (ON_DEMAND, SPOT).<br>    capacity_type = string<br>    # Instance type.<br>    node_instance_type = string<br>    # Disk size (GB).<br>    disk_size = number<br>    # Minimum number of nodes.<br>    min_size = number<br>    # Maximum number of nodes.<br>    max_size = number<br>    # Value for k8s.amazonaws.com/accelerator.<br>    accelerator_label = string<br>    # Additional taints.<br>    additional_taints = list(object({<br>      key    = string<br>      value  = string<br>      effect = string<br>    }))<br>    # Additional labels.<br>    additional_labels = map(string)<br>  }))</pre> | <pre>[<br>  {<br>    "accelerator_label": "nvidia-tesla-t4",<br>    "additional_labels": {},<br>    "additional_taints": [],<br>    "capacity_type": "ON_DEMAND",<br>    "disk_size": 100,<br>    "max_size": 3,<br>    "min_size": 0,<br>    "node_instance_category": "gpu",<br>    "node_instance_type": "g4dn.xlarge",<br>    "suffix": "gpu"<br>  }<br>]</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnets to place the EKS cluster and workers within. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of VPC where the cluster and workers will be deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the EKS cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the EKS cluster. |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider. |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | ID of the EKS cluster security group. |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | ID of the EKS cluster additional security group. |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | ID of the EKS node shared security group. |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`). |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the OIDC Provider. |
<!-- END_TF_DOCS -->
