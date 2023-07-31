terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.30.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region

  default_tags {
    tags = {
      ManagedByTerraform = true
      Environment        = var.environment
      TerraformLocation  = ""
    }
  }
}