# Exafunction Moduel Repository Backend Module

This Terraform module is used to set up resources that provide a persistent backend for the ExaDeploy module repository. It is responsible for creating an S3 bucket and an RDS instance that will be used to store the module repository's objects and metadata respectively. This backend allows the data to be persisted even if the module repository pod is rescheduled. As an alternative to this persistent backend, the module repository also supports a fully local backend (backed by its own local filesystem on disk) which is not persisted if the module repository pod is rescheduled.

## Usage
```hcl
module "exafunction_module_repo_backend" {
  # Set the module source to use this module.
  source = "Exafunction/exafunction-cloud/aws//modules/module_repo_backend"

  # Set a unique identifier for created resources.
  exadeploy_id = "exafunction"

  # Set the subnet group name and security group IDs to attach to the RDS instance.
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = ["sg-abcd1234", "sg-abcd5678"]

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/module_repo_backend/variables.tf) file for a full list of configuration options.

See [examples/simple_module_repo_backend](https://github.com/Exafunction/terraform-aws-exafunction-cloud/tree/main/modules/module_repo_backend/examples/simple_module_repo_backend) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-aws-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_db_instance.default_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_iam_access_key.s3_iam_user_access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.s3_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_s3_bucket.module_repository_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.module_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.module_repository_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.module_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.bucket_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | RDS instance class. | `string` | `"db.t4g.micro"` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | RDS database port. | `number` | `5432` | no |
| <a name="input_db_storage"></a> [db\_storage](#input\_db\_storage) | RDS storage size in GB. | `number` | `10` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of database subnet group to attach to. | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | RDS database username. | `string` | `"postgres"` | no |
| <a name="input_exadeploy_id"></a> [exadeploy\_id](#input\_exadeploy\_id) | Unique identifier for a deployment of the ExaDeploy system. | `string` | `"exafunction"` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | RDS Postgres version. | `string` | `"13.4"` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_address"></a> [rds\_address](#output\_rds\_address) | Address for the RDS instance. |
| <a name="output_rds_password"></a> [rds\_password](#output\_rds\_password) | Password for the RDS instance. |
| <a name="output_rds_port"></a> [rds\_port](#output\_rds\_port) | Port for the RDS instance. |
| <a name="output_rds_username"></a> [rds\_username](#output\_rds\_username) | Username for the RDS instance. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | ID of the S3 bucket. |
| <a name="output_s3_iam_user_access_key"></a> [s3\_iam\_user\_access\_key](#output\_s3\_iam\_user\_access\_key) | Access key for the S3 IAM user. |
| <a name="output_s3_iam_user_secret_key"></a> [s3\_iam\_user\_secret\_key](#output\_s3\_iam\_user\_secret\_key) | Secret key for the S3 IAM user. |
<!-- END_TF_DOCS -->
