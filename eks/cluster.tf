provider "aws" {
    region = var.region
}

# Cluster
resource "aws_eks_cluster" "main-cluster" {
    enabled_cluster_log_types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager",
        "scheduler",
    ]
    name       = var.cluster_name
    role_arn   = aws_iam_role.eks-cluster-service-role.arn
    version    = var.cluster_version

    vpc_config {
        endpoint_private_access = true
        endpoint_public_access  = true
        public_access_cidrs = [
            "0.0.0.0/0",
        ]
        security_group_ids = var.security_group_ids
        subnet_ids = var.subnet_ids
    }
}

# Addons
resource "aws_eks_addon" "add_aws-ebs-csi-driver" {
    cluster_name = aws_eks_cluster.main-cluster.name
    addon_name   = "aws-ebs-csi-driver"
}

resource "aws_eks_addon" "add_vpccni" {
    cluster_name = aws_eks_cluster.main-cluster.name
    addon_name   = "vpc-cni"
}


resource "aws_eks_addon" "add_kubeproxy" {
    cluster_name = aws_eks_cluster.main-cluster.name
    addon_name   = "kube-proxy"
}

