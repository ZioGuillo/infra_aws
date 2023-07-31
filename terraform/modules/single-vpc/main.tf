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
  profile = "zonered"
  region  = var.aws_region

  default_tags {
    tags = {
      ManagedByTerraform = true
      Environment        = var.environment
      TerraformLocation  = ""
    }
  }
}