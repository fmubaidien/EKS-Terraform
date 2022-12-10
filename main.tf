module "network" {
    source = "./network"

    region = "eu-west-1"	
    main_vpc_cidr = "10.0.0.0/21"

    az_0 = "eu-west-1a"
    az_1 = "eu-west-1b"
    az_2 = "eu-west-1c"
    nat_az = "eu-west-1a"

    public_subnet_0 = "10.0.0.0/24"
    public_subnet_1 = "10.0.1.0/24"
    public_subnet_2 = "10.0.2.0/24"

    private_subnet_0 =  "10.0.3.0/24"
    private_subnet_1 =  "10.0.4.0/24"
    private_subnet_2 = "10.0.5.0/24"

    nat_subnet = "10.0.6.0/24"

}

module "eks" {
    source = "./eks"

    region = "eu-west-1"
    cluster_name = "main-cluster"
    cluster_version = "1.22"
    security_group_ids = [module.network.cluster-nodes-sg.id, module.network.cluster-control-sg.id ]
    subnet_ids = [module.network.public_subnet_0.id, module.network.public_subnet_1.id, module.network.public_subnet_2.id]
    eks_worker_instance_type = "t3.medium"
    node_pool_desired = 3
    node_pool_min = 1
    node_pool_max = 5
}