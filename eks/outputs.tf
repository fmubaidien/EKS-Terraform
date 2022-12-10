output cluster-name {
    value=aws_eks_cluster.main-cluster.name
}

output cluster-sg {
    value=aws_eks_cluster.main-cluster.vpc_config[0].cluster_security_group_id
}

output ca {
    value=aws_eks_cluster.main-cluster.certificate_authority[0].data
}

output endpoint {
    value=aws_eks_cluster.main-cluster.endpoint
}