# IAM role for workflows

resource "aws_iam_role" "dl_admin" {
  name               = "DataLake-Admin"
  assume_role_policy = data.aws_iam_policy_document.dl_admin_assume.json

  description = "Data Lake Formation administrators"
}

# Trust Relationships

# data aws_iam_role sso_admins {
#   name = "AWSReservedSSO_AdministratorAccess_ec9b18fd3f57c883" 
# }

data "aws_iam_policy_document" "dl_admin_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.allowed_dl_admins
    }

    effect = "Allow"
  }
}

# Attached Policies

# AWSLakeFormationDataAdmin

data "aws_iam_policy" "dl_admin_formation_admin" {
  name = "AWSLakeFormationDataAdmin"
}

resource "aws_iam_role_policy_attachment" "dl_admin_formation_admin" {
  role       = aws_iam_role.dl_admin.name
  policy_arn = data.aws_iam_policy.dl_admin_formation_admin.arn
}

# AWSGlueConsoleFullAccess 

data "aws_iam_policy" "dl_admin_glue_admin" {
  name = "AWSGlueConsoleFullAccess"
}

resource "aws_iam_role_policy_attachment" "dl_admin_glue_admin" {
  role       = aws_iam_role.dl_admin.name
  policy_arn = data.aws_iam_policy.dl_admin_glue_admin.arn
}

# CloudWatchLogsReadOnlyAccess

data "aws_iam_policy" "dl_admin_cw_readonly" {
  name = "CloudWatchLogsReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "dl_admin_cw_readonly" {
  role       = aws_iam_role.dl_admin.name
  policy_arn = data.aws_iam_policy.dl_admin_cw_readonly.arn
}

# AmazonAthenaFullAccess

data "aws_iam_policy" "dl_admin_athena_full" {
  name = "AmazonAthenaFullAccess"
}

resource "aws_iam_role_policy_attachment" "dl_admin_athena_full" {
  role       = aws_iam_role.dl_admin.name
  policy_arn = data.aws_iam_policy.dl_admin_athena_full.arn
}

# Inline Policies

# RAMAccess
# Allow granting or receiving cross-account Lake Formation permissions

# data "aws_iam_policy_document" "dl_admin_ramaccess" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ram:AcceptResourceShareInvitation",
#       "ram:RejectResourceShareInvitation",
#       "ec2:DescribeAvailabilityZones",
#       "ram:EnableSharingWithAwsOrganization"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "dl_admin_ramaccess" {
#     name = "RAMAccess"
#     role = aws_iam_role.dl_admin.id
#     policy = data.aws_iam_policy_document.dl_admin_ramaccess.json
# }

# UserPassRole
# Allow permissions to create and run workflows

data "aws_iam_policy_document" "dl_admin_userpassrole" {
  statement {
    sid     = "PassRolePermissions"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.workflow.arn,
      aws_iam_role.dl_slr.arn
    ]
  }
}


resource "aws_iam_role_policy" "dl_admin_userpassrole" {
  name   = "UserPassRole"
  role   = aws_iam_role.dl_admin.id
  policy = data.aws_iam_policy_document.dl_admin_userpassrole.json
}

# TBAC
# Metadata access control using the tag-based access control (TBAC) method

data "aws_iam_policy_document" "dl_admin_tbac" {
  statement {
    effect = "Allow"
    actions = [
      "lakeformation:AddLFTagsToResource",
      "lakeformation:RemoveLFTagsFromResource",
      "lakeformation:GetResourceLFTags",
      "lakeformation:ListLFTags",
      "lakeformation:CreateLFTag",
      "lakeformation:GetLFTag",
      "lakeformation:UpdateLFTag",
      "lakeformation:DeleteLFTag",
      "lakeformation:SearchTablesByLFTags",
      "lakeformation:SearchDatabasesByLFTags"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role_policy" "dl_admin_tbac" {
  name   = "LakeFormationTBAC"
  role   = aws_iam_role.dl_admin.id
  policy = data.aws_iam_policy_document.dl_admin_tbac.json
}


# SL Role Creation
# Allow creation of service linked roles

# data "aws_iam_policy_document" "dl_admin_slr" {
#   statement {
#       effect = "Allow"
#       actions = ["iam:CreateServiceLinkedRole"]
#       resources = ["*"]
#       condition {
#         test = "StringEquals"
#         variable = "iam:AWSServiceName"
#         values = ["lakeformation.amazonaws.com"]
#       }
#   }
#   statement {
#     effect = "Allow"
#     actions = ["iam:PutRolePolicy"]
#     resources = ["arn:aws:iam::<account-id>:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"]
#   }
# }


# resource "aws_iam_role_policy" "dl_admin_slr" {
#     name = "LakeFormationSLR"
#     role = aws_iam_role.dl_admin.id
#     policy = data.aws_iam_policy_document.dl_admin_slr.json
# }
