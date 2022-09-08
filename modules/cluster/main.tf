module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "> 18.20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  enable_irsa               = true
  manage_aws_auth_configmap = false

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      type        = "ingress"
      protocol    = "all"
      from_port   = 0
      to_port     = 0
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      type             = "egress"
      protocol         = "all"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    launch_template_tags = var.instance_tags
  }

  # Note that `block_device_mappings` is used because `disk_size` is not supported when using a
  # custom launch template. Device name `/dev/xvda` is hard coded since it is the expected root
  # device name for the AMIs used by the launch template. For Nitro-based instances, this is
  # symlinked to an NVMe device name.
  eks_managed_node_groups = merge({
    for runner_pool in var.runner_pools : "runner-${runner_pool.suffix}" => {
      name           = "runner-${runner_pool.suffix}"
      ami_type       = runner_pool.node_instance_category == "cpu" ? "AL2_x86_64" : "AL2_x86_64_GPU"
      capacity_type  = runner_pool.capacity_type
      instance_types = [runner_pool.node_instance_type]
      desired_size   = runner_pool.min_size
      min_size       = runner_pool.min_size
      max_size       = runner_pool.max_size
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = runner_pool.disk_size
            delete_on_termination = true
          }
        }
      }
      taints = concat([
        {
          key    = "dedicated"
          value  = "runner"
          effect = "NO_SCHEDULE"
        }],
        runner_pool.node_instance_category == "gpu" ? [{
          key    = "nvidia.com/gpu"
          value  = "present"
          effect = "NO_SCHEDULE"
        }] : [],
      runner_pool.additional_taints)
      labels = merge({
        role = "runner"
        }, runner_pool.accelerator_label != "" ? {
        "k8s.amazonaws.com/accelerator" = runner_pool.accelerator_label
        } : {}, runner_pool.node_instance_category == "gpu" ? {
        "nvidia.com/gpu" = "present"
        } : {},
      runner_pool.additional_labels)
    }
    }, {
    "default" = {
      name           = "default"
      instance_types = ["m5.xlarge"]
      desired_size   = 1
      min_size       = 1
      max_size       = 10
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            delete_on_termination = true
          }
        }
      }
    }
    "scheduler" = {
      name           = "scheduler"
      instance_types = ["c5.xlarge"]
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            delete_on_termination = true
          }
        }
      }
      taints = [
        {
          key    = "dedicated"
          value  = "scheduler"
          effect = "NO_SCHEDULE"
        }
      ]
      labels = {
        role = "scheduler"
      }
    }
    "module-repository" = {
      name           = "module-repository"
      instance_types = ["c5.xlarge"]
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            delete_on_termination = true
          }
        }
      }
      taints = [
        {
          key    = "dedicated"
          value  = "module-repository"
          effect = "NO_SCHEDULE"
        }
      ]
      labels = {
        role = "module-repository"
      }
    }
    "prometheus" = {
      name           = "prometheus"
      instance_types = ["m5.xlarge"]
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            delete_on_termination = true
          }
        }
      }
      taints = [
        {
          key    = "dedicated"
          value  = "prometheus"
          effect = "NO_SCHEDULE"
        }
      ]
      labels = {
        role = "prometheus"
      }
    }
  }, var.additional_node_groups)
}

locals {
  # Map from runner pool suffix to node group resources
  node_group_resource_map = {
    for runner_pool in var.runner_pools :
    runner_pool.suffix => module.eks.eks_managed_node_groups["runner-${runner_pool.suffix}"].node_group_resources
  }
}

resource "aws_autoscaling_group_tag" "autoscaler_scale_to_zero" {
  for_each               = local.node_group_resource_map
  autoscaling_group_name = one(one(each.value).autoscaling_groups).name
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/role"
    propagate_at_launch = "false"
    value               = "runner"
  }
}

# Add security group rule to enable inbound traffic from within the VPC (including instances outside
# the cluster).
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_security_group_rule" "exafunction_ingress_in_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  security_group_id = module.eks.cluster_primary_security_group_id
}
