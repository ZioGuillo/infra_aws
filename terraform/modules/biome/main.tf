terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}

provider "aws" {
  profile = "${var.organization}-${var.environment}"
  region  = var.aws_region

  default_tags {
    tags = {
      ManagedByTerraform = true
      Environment        = var.environment
      TerraformLocation  = "https://github.com/"
    }
  }
}

provider "kubernetes" {
  alias                  = "default"
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args = [
      "eks", "get-token",
      "--profile", "${var.organization}-${var.environment}",
      "--cluster-name", local.eks_cluster_name
    ]
    command = "aws"
  }
}