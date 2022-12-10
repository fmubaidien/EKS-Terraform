provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "main" {           
  instance_tenancy = "default"
  cidr_block = var.main_vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    name = "main-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create public subnets
resource "aws_subnet" "public_subnet_0" { 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_0
  availability_zone = var.az_0
  map_public_ip_on_launch = true
  tags = {
    "Name" = "pb-sn-${var.az_0}"
  }
}

resource "aws_subnet" "public_subnet_1" { 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_1
  availability_zone = var.az_1
  map_public_ip_on_launch = true
  tags = {
    "Name" = "pb-sn-${var.az_1}"
  }
}

resource "aws_subnet" "public_subnet_2" { 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_2
  availability_zone = var.az_2
  map_public_ip_on_launch = true
  tags = {
    "Name" = "pb-sn-${var.az_2}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnet_0" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_0
  availability_zone = var.az_0
  map_public_ip_on_launch = false
  tags = {
    "Name" = "pv-sn-${var.az_0}"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_1
  availability_zone = var.az_1
  map_public_ip_on_launch = false
  tags = {
    "Name" = "pv-sn-${var.az_1}"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_2
  availability_zone = var.az_2
  map_public_ip_on_launch = false
  tags = {
    "Name" = "pv-sn-${var.az_2}"
  }
}

# Create nat subnet and gateway
resource "aws_subnet" "nat_subnet" { 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.nat_subnet
  availability_zone = var.nat_az
  map_public_ip_on_launch = true
  tags = {
    "Name" = "nat-sn"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.nat_subnet.id
}

# Create route tables
resource "aws_route_table" "public_rt" { 
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table" "nat_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from nat reaches internet via internetgateway
    gateway_id = aws_internet_gateway.igw.id
  }
}

## Nat route table association
resource "aws_route_table_association" "nat_rt_association" {
  subnet_id      = aws_subnet.nat_subnet.id
  route_table_id = aws_route_table.nat_rt.id
}

## Public route table associations
resource "aws_route_table_association" "public_rt_association_0" {
  subnet_id      = aws_subnet.public_subnet_0.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

## Private route table associations
resource "aws_route_table_association" "private_rt_association_0" {
  subnet_id      = aws_subnet.private_subnet_0.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Create database subnet groups for private and public subnets
resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "private_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_0.id, aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "private db subnet group"
  }
}

resource "aws_db_subnet_group" "public_db_subnet_group" {
  name       = "public_subnet_group"
  subnet_ids = [aws_subnet.public_subnet_0.id, aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "public db subnet group"
  }
}

resource "aws_elasticache_subnet_group" "private_elasticache_subnet_group" {
  name       = "private-elasticache-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_0.id, aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

resource "aws_dax_subnet_group" "private_dax_subnet_group" {
  name       = "private-dax-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_0.id, aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}