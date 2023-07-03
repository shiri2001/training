module "add-eks-private-subnet" {
  source               = "..//modules/add-eks-private-subnet"
  region               = var.region
  eks_cluster_name     = "api-k8s-cluster"
}