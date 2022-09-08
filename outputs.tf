output "exafunction_network" {
  description = "Exafunction network module."
  value       = module.exafunction_network
}

output "exafunction_cluster" {
  description = "Exafunction cluster module."
  value       = module.exafunction_cluster
}

output "exafunction_module_repo_backend" {
  description = "Exafunction module repository backend module."
  value       = module.exafunction_module_repo_backend
  sensitive   = true
}

output "exafunction_peering" {
  description = "Exafunction peering module."
  value       = module.exafunction_peering
}

output "peer_vpc_id" {
  description = "ID of the peer VPC."
  value       = module.peer_vpc.vpc_id
}
