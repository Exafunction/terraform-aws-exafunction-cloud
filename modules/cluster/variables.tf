variable "cluster_name" {
  description = "Name of the EKS cluster to create."
  type        = string
  default     = "exafunction-cluster"

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]+$", var.cluster_name))
    error_message = "Invalid cluster name format."
  }

  validation {
    condition     = length(var.cluster_name) <= 29
    error_message = "Cluster name length must be <= 29."
  }
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (for example 1.22)."
  type        = string
  default     = "1.22"
}

variable "vpc_id" {
  description = "ID of VPC where the cluster and workers will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
}

variable "runner_pools" {
  description = "Configuration parameters for Exafunction runner node pools."
  type = list(object({
    # Node group suffix.
    suffix = string
    # One of (cpu, gpu, inferentia).
    node_instance_category = string
    # One of (ON_DEMAND, SPOT).
    capacity_type = string
    # Instance type.
    node_instance_type = string
    # Disk size.
    disk_size = number
    # Minimum number of nodes.
    min_size = number
    # Maximum number of nodes.
    max_size = number
    # Value for k8s.amazonaws.com/accelerator.
    accelerator_label = string
    # Additional taints.
    additional_taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    # Additional labels.
    additional_labels = map(string)
  }))
  default = [{
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
  validation {
    condition = alltrue([
      for runner_pool in var.runner_pools : contains(["cpu", "gpu", "inferentia"], runner_pool.node_instance_category)
    ])
    error_message = "Node instance category be one of [cpu, gpu, inferentia]."
  }
  validation {
    condition = alltrue([
      for runner_pool in var.runner_pools : contains(["ON_DEMAND", "SPOT"], runner_pool.capacity_type)
    ])
    error_message = "Capacity type be one of [ON_DEMAND, SPOT]."
  }
}

variable "additional_node_groups" {
  description = "Map of additional EKS managed node group definitions to create. For schema, see https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v18.29.0/modules/eks-managed-node-group/README.md#inputs."
  type        = any
  default     = {}
}

variable "instance_tags" {
  description = "Tags to apply to all EC2 instances managed by the cluster."
  type        = map(string)
  default     = {}
}
