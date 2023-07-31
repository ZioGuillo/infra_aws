locals {
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Extract the variables we need for easy access
  aws_region   = local.region_vars.locals.aws_region
  environment  = local.environment_vars.locals.environment
  
}

terraform {
  source = "${get_terragrunt_dir()}../../../../../../modules//single-vpc"
}

include {
  path = find_in_parent_folders()
}

#dependency "" { 
#}

inputs = {

  name                 = "ibrain"
  vpc_cidr             = "10.0"
  public_subnets_cidr  = ["10.0.2.0/24"]
  private_subnets_cidr = ["10.0.20.0/24"]
  availability_zones   = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]

}
