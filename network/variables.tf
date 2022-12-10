# Region var
variable "region" {}

# cidr for VPC
variable "main_vpc_cidr" {}

# Public subnet cidrs (Make sure not to overlap)
variable "public_subnet_0" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}

# Private subnet cidrs (Make sure not to overlap)
variable "private_subnet_0" {}
variable "private_subnet_1" {}
variable "private_subnet_2" {}

# Cidr for nat subnet
variable "nat_subnet" {}
variable "nat_az" {}

# Availability zones
variable "az_0" {}
variable "az_1" {}
variable "az_2" {}

