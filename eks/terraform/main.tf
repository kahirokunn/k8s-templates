locals {
  config = jsondecode(file("${path.module}/../../config.json"))
}

provider "aws" {
  region = local.config.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = local.config.vpc_name
  cidr = local.config.vpc_cidr

  azs             = local.config.azs
  private_subnets = local.config.private_subnets
  public_subnets  = local.config.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {for i in range(local.config.eks_max_cluster_number) : "kubernetes.io/cluster/${local.config.base_cluster_name}-${i}" => "shared"}

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
