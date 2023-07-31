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
  source = "${get_terragrunt_dir()}../../../../../../modules//biome"
}

include {
  path = find_in_parent_folders()
}

dependency "simple-vpc" {
  config_path = "../simple-vpc"
}

inputs = {
  name               = "default"
  public_subnets_cidr = dependency.vpc.public_subnets_cidr
  private_subnets_cidr = dependency.vpc.private_subnets_cidr
  cidr_base          = "10.110"
  kubernetes_version = "1.21"
  organization       = "ibrain"

  # Admin role from AWS SSO
  # Note: this setting does not do anything because of the kubernetes_config_map_ignore_role_changes being defaulted to true
  # See https://github.com/hivewatch/terraform-aws-eks-cluster#readme for more info

  /* map_additional_iam_roles = [
    dependency.github-oidc.outputs.map_github_actions_role
  ] */

  /* map_additional_iam_users = [{
    userarn  = "arn:aws:iam::186261620940:user/github.backend-kotlin-dev.terraform"
    username = "terraform"
    groups   = ["system:masters"]
    }, {
    userarn  = "arn:aws:iam::186261620940:user/github.graphql-gateway-dev.terraform"
    username = "terraform"
    groups   = ["system:masters"]
  } ]
*/
  endpoint_public_access = true
  endpoint_private_access = true
  use_legacy_eks_name = true
}