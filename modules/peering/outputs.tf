output "peering_connection_id" {
  description = "ID of the VPC peering connection."
  value       = aws_vpc_peering_connection.exafunction.id
}

output "egress_route_ids" {
  description = "ID of the egress (Exafunction VPC to peering connection) route."
  value       = [for route in aws_route.exafunction : route.id]
}

output "ingress_route_ids" {
  description = "IDs of the ingress (peer VPC to peering connection) routes."
  value       = [for route in aws_route.peer : route.id]
}

output "ingress_security_group_rule_id" {
  description = "ID of the security group rule allowing ingress from the peer VPC."
  value       = aws_security_group_rule.exafunction_ingress.id
}
