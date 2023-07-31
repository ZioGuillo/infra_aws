module "this" {
  source  = "cloudposse/label/null"
  version = "0.24.1" # requires Terraform >= 0.13.0

  enabled     = true
  namespace   = var.use_legacy_eks_name ? null : var.organization
  environment = var.environment
  stage       = var.use_legacy_eks_name ? null : var.aws_region
  name        = var.name
  delimiter   = null
  attributes  = []
  tags = {
    ManagedByTerraform = true
  }
  additional_tag_map  = {}
  label_order         = []
  regex_replace_chars = null
  id_length_limit     = null
  label_key_case      = null
  label_value_case    = null
}
