# VPC
output "main_vpc" {
  value = aws_vpc.main
}

# Public subnets
output "public_subnet_0" {
  value = aws_subnet.public_subnet_0
}

output "public_subnet_1" {
  value = aws_subnet.public_subnet_1
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet_2
}

# Private subnets
output "private_subnet_0" {
  value = aws_subnet.private_subnet_0
}

output "private_subnet_1" {
  value = aws_subnet.private_subnet_1
}

output "private_subnet_2" {
  value = aws_subnet.private_subnet_2
}

# Subnet Groups
output "public_subnet_group" {
  value = aws_db_subnet_group.public_db_subnet_group
}

output "private_subnet_group" {
  value = aws_db_subnet_group.private_db_subnet_group
}

output "private_elasticache_subnet_group" {
  value = aws_elasticache_subnet_group.private_elasticache_subnet_group
}

output "private_dax_subnet_group" {
  value = aws_dax_subnet_group.private_dax_subnet_group
}

# Security groups
output "cluster-nodes-sg" {
  value = aws_security_group.cluster-nodes-sg
}

output "cluster-control-sg" {
    value = aws_security_group.cluster-control-sg
}

