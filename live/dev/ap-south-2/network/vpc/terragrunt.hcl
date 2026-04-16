include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=6.6.0"
  # Direct invocation of the public module pinned to specific version
  # See https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest for more details
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env
  cluster_name = local.env_vars.locals.cluster_name

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region
}

inputs = {
  name = "main-vpc-${local.env}"
  cidr = "10.0.0.0/16"
  
  azs             = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway  = true
  single_nat_gateway  = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Adding this tag helps EKS 'discover' the subnets
    "kubernetes.io/cluster/${local.cluster_name}" = "owned" 
  }

  # Useful standard tagging
  tags = {
    Project     = "AWS-Learning"
    Environment = local.env
    ManagedBy   = "Terragrunt"
  }
}
