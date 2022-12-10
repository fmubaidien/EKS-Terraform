resource "aws_eks_node_group" "ng1" {
    cluster_name   = aws_eks_cluster.main-cluster.name
    disk_size      = 10
    labels = {
        "alpha.eksctl.io/cluster-name"   = aws_eks_cluster.main-cluster.name
        "alpha.eksctl.io/nodegroup-name" = "ng1-main-cluster"
    }
    node_group_name = "ng1-main-cluster"
    node_role_arn   = aws_iam_role.eks-nodegroup-role.arn
    subnet_ids = var.subnet_ids
    tags = {
        "alpha.eksctl.io/cluster-name"                = aws_eks_cluster.main-cluster.name
    }
    #version = "1.17"
    scaling_config {
        desired_size = var.node_pool_desired
        max_size     = var.node_pool_max
        min_size     = var.node_pool_min
    }
}