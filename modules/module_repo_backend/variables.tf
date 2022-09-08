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
  default     = "13.4"
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

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate."
  type        = list(string)
}
