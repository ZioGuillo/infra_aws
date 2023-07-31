module "vpc" {
  source = "../single-vpc"

  name        = var.name
  environment = var.environment
  prefix      = "default"
  region      = module.vpc.aws_region
  cidr_base   = module.vpc.cidr_base
}

locals {
  private_subnets_ids = [
    for key, val in module.vpc.subnets : val.id
    if replace(key, "private-", "") != key && replace(key, "private-elb", "") == key
  ]
/*   fortknox_subnets_ids = [
    for key, val in module.vpc.subnets : val.id
    if replace(key, "fortknox-", "") != key
  ] */
}

/* resource "aws_db_subnet_group" "biome" {
  name        = "biome-${var.name}"
  description = "Default db subnet group for biome-${var.name}"
  subnet_ids  = local.fortknox_subnets_ids
} */