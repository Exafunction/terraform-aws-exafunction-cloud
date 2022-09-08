variable "vpc_name" {
  description = "Name of VPC to create."
  type        = string
  default     = "exafunction-vpc"

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{3,63}$", var.vpc_name))
    error_message = "Invalid VPC name format."
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block range for VPC to create."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}\\/[0-9]{1,2}$", var.vpc_cidr_block))
    error_message = "Invalid VPC CIDR range format."
  }
}
