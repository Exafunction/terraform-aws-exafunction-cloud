output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = module.eks.cluster_arn
}

output "cluster_primary_security_group_id" {
  description = "ID of the EKS cluster security group."
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  description = "ID of the EKS cluster additional security group."
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "ID of the EKS node shared security group."
  value       = module.eks.node_security_group_id
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider."
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)."
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider."
  value       = module.eks.oidc_provider_arn
}
