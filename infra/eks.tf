module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "llm_gateway_eks_cluster"
  kubernetes_version = "1.36"

  addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      before_compute = true
      most_recent    = true
    }
  }

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = true

  eks_managed_node_groups = {
    workers = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1

      security_group_egress_rules = {
        egress_all = {
          description = "Allow all egress"
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }
}

resource "kubernetes_service_account_v1" "test" {
  metadata {
    name      = "test-sa"
    namespace = "default"
  }

  depends_on = [module.eks]
}
