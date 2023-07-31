locals {
  eks_cluster_name = var.use_legacy_eks_name ? "${var.environment}-${var.eks_name}-cluster" : "${var.organization}-${var.environment}-${var.aws_region}-${var.eks_name}-cluster"

  admin_role_arn = tolist(aws_iam_roles.eks.arns)[0]
  admin_role_object = {
    rolearn  = local.admin_role_arn
    username = "admin/{{SessionName}}"
    groups   = ["default:eks-admins"]
  }

  map_additional_iam_roles = concat(var.map_additional_iam_roles, [local.admin_role_object])
}