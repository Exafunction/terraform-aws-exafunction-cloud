variable "vpc_id" {
  description = "ID of the Exafunction VPC."
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs in the Exafunction VPC to add routes to."
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group to allow ingress for."
  type        = string
}

variable "peer_vpc_id" {
  description = "ID of the peer VPC."
  type        = string
}

variable "peer_route_table_ids" {
  description = "List of route table IDs for the peer VPC to add routes to."
  type        = list(string)
}
