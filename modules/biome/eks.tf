resource "aws_eks_cluster" "example" {
  name                = var.name
  role_arn            = aws_iam_role.example.arn
  vpc_config {
    security_group_ids = [aws_security_group.eks.id]
    subnet_ids         = [aws_subnet.public.id, aws_subnet.private.id]
  }
  oidc_provider_enabled = true
  enabled_cluster_log_types    = var.enabled_cluster_log_types
  cluster_log_retention_period = var.cluster_log_retention_period

  map_additional_iam_roles = local.map_additional_iam_roles
  map_additional_iam_users = var.map_additional_iam_users

  // @TODO: setup encryption for etcd for prod
  cluster_encryption_config_enabled         = false
  kubernetes_config_map_ignore_role_changes = true

  public_access_cidrs = var.public_access_cidrs

  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access

  context = module.label.context
}


module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"
  enabled = var.enable_eks
  context = module.this.context
}