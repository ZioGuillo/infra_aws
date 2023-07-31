provider "aws" {
  region  = var.aws_region

  default_tags {
    tags = {
      ManagedByTerraform = true
      Environment        = var.environment
    }
  }
}

provider "aws" {
  alias   = "dl_admin"
  region  = var.aws_region

  assume_role {
    role_arn = aws_iam_role.dl_admin.arn
  }

  default_tags {
    tags = {
      ManagedByTerraform = true
      Environment        = var.environment
    }
  }
}