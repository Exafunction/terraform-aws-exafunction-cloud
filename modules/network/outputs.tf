output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "Name of the created VPC."
  value       = module.vpc.name
}

output "vpc_arn" {
  description = "ARN of the created VPC."
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC."
  value       = module.vpc.vpc_cidr_block
}

output "azs" {
  description = "Availability zones of the created VPC."
  value       = module.vpc.azs
}

output "private_subnets" {
  description = "List of IDs of private subnets in the created VPC."
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets in the created VPC."
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets in the created VPC."
  value       = module.vpc.database_subnets
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets in the created VPC."
  value       = module.vpc.private_subnet_arns
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets in the created VPC."
  value       = module.vpc.public_subnet_arns
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets in the created VPC."
  value       = module.vpc.database_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks for private subnets in the created VPC."
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets_cidr_blocks" {
  description = "List of CIDR blocks for public subnets in the created VPC."
  value       = module.vpc.public_subnets_cidr_blocks
}

output "database_subnets_cidr_blocks" {
  description = "List of CIDR blocks for database subnets in the created VPC."
  value       = module.vpc.database_subnets_cidr_blocks
}

output "private_route_table_ids" {
  description = "List of route table IDs for private subnets in the created VPC."
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "List of route table IDs for public subnets in the created VPC."
  value       = module.vpc.public_route_table_ids
}

output "database_route_table_ids" {
  description = "List of route table IDs for database subnets in the created VPC."
  value       = module.vpc.database_route_table_ids
}

output "database_subnet_group" {
  description = "ID of the database subnet group in the created VPC."
  value       = module.vpc.database_subnet_group
}

output "database_subnet_group_name" {
  description = "Name of the database subnet group in the created VPC."
  value       = module.vpc.database_subnet_group_name
}
