variable "exadeploy_id" {
  description = "Unique identifier for a deployment of the ExaDeploy system."
  type        = string
  default     = "exafunction"

  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.exadeploy_id))
    error_message = "Invalid ExaDeploy ID."
  }
}

variable "db_storage" {
  description = "RDS storage size in GB."
  type        = number
  default     = 10
}

variable "postgres_version" {
  description = "RDS Postgres version."
  type        = string
  default     = "13"

  validation {
    condition     = can(regex("^[0-9]+$", var.postgres_version))
    error_message = "Postgres version may only specify a major version (to avoid Terraform conflicts due to RDS auto minor version upgrades)."
  }
}

variable "db_username" {
  description = "RDS database username."
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "RDS database port."
  type        = number
  default     = 5432
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_subnet_group_name" {
  description = "Name of database subnet group to attach to."
  type        = string
}

variable "db_storage_encrypted" {
  description = "Whether the database storage is encrypted."
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate."
  type        = list(string)
}
