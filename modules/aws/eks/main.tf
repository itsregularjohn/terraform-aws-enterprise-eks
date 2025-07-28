module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  bootstrap_self_managed_addons = true

  create_kms_key = local.create_kms_key

  cluster_encryption_config = {
    provider_key_arn = var.kms_key_arn
    resources        = ["secrets"]
  }

  access_entries = {
    terraform_execution = {
      kubernetes_groups = []
      principal_arn     = var.sso_terraform_role_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    organization_admin = {
      kubernetes_groups = []
      principal_arn     = local.organization_admin_role_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  cluster_addons = {
    vpc-cni = {
      before_compute = true
    }
    kube-proxy = {}
  }

  eks_managed_node_groups = {
    application = {
      name                            = "application"
      node_group_name_prefix          = var.cluster_name
      ami_type                        = "AL2023_x86_64_STANDARD"
      min_size                        = 4
      max_size                        = 4
      desired_size                    = 4
      instance_types                  = ["t3.medium"]
      launch_template_use_name_prefix = true
      use_name_prefix                 = false
      launch_template = {
        name    = local.node_group_name
        version = "latest_version"
      }

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
}
