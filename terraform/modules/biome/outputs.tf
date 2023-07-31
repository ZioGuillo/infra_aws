output "vpc" {
  value = module.vpc
}

output "eks" {
  value = module.eks_cluster
}

output "eks_context" {
  value = module.label
}

/* output "db_subnet_group" {
  value = aws_db_subnet_group.biome
} */

output "admin_role_arn" {
  value     = local.admin_role_arn
  sensitive = true
}