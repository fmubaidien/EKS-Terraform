resource "aws_security_group" "cluster-nodes-sg" {
    name = "control-sg"
    description = "Communication between all nodes in the cluster"
    vpc_id      = aws_vpc.main.id

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        "Name"   = "cluster-nodes-sg"
    }
}

resource "aws_security_group" "cluster-control-sg" {
    description = "Communication between the control plane and worker nodegroups"
    vpc_id      = aws_vpc.main.id

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }



    tags = {
        "Name" = "cluster-control-sg"
    }
}

resource "aws_security_group_rule" "allow-nodes-sg" {
    type              = "ingress"
    to_port           = 0
    from_port         = 0
    protocol          = "-1"
    source_security_group_id = aws_security_group.cluster-nodes-sg.id
    security_group_id = aws_security_group.cluster-nodes-sg.id
}

resource "aws_security_group_rule" "allow-control-sg" {
    type              = "ingress"
    to_port           = 0
    from_port         = 0
    protocol          = "-1"
    source_security_group_id = aws_security_group.cluster-control-sg.id
    security_group_id = aws_security_group.cluster-control-sg.id
}