module "eks" {
  source                      = "terraform-aws-modules/eks/aws"
  version                     = "18.20.4"
  cluster_name                = local.cluster_name
  cluster_version             = "1.23"
  subnet_ids                  = module.vpc.private_subnets
  vpc_id                      = module.vpc.vpc_id
  create_cloudwatch_log_group = false

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.medium"]
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
