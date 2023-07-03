data "aws_vpc" "default" {
  default = true
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.22.0"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  cluster_version = "1.21"
  cluster_name    = "api-k8s-cluster"
  vpc_id          = data.aws_vpc.default.id
  subnets         = module.add-eks-private-subnet.private_subnet_blocks

  enable_irsa = true

    eks_managed_node_groups = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
        
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"
    }
}