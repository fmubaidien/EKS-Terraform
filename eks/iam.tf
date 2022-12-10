# EKS IAM Role
resource "aws_iam_role" "eks-cluster-service-role" {
    assume_role_policy = jsonencode(
    {
        Statement = [
            {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = [
                "eks-fargate-pods.amazonaws.com",
                "eks.amazonaws.com",
                ]
            }
            },
        ]
        Version = "2012-10-17"
    }
    )
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "eks-cluster-service-role"
    path                  = "/"
    tags = {
    "Name"  = "eks-cluster/ServiceRole"
    }
}

# EKS nodes IAM Role
resource "aws_iam_role" "eks-nodegroup-role" {
    assume_role_policy = jsonencode(
    {
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
        Version = "2012-10-17"
    }
    )
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "eks-nodegroup-role"
    path                  = "/"
    tags = {
    "Name" = "eks-nodegroup-role/NodeInstanceRole"
    }
}

#Policy attachments for service account
resource "aws_iam_role_policy_attachment" "service-attachment-1" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks-cluster-service-role.name
}

#Policy attachments for nodegroup
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.eks-nodegroup-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.eks-nodegroup-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.eks-nodegroup-role.name
}
