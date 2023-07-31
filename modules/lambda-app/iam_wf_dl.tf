# IAM role for workflows

resource "aws_iam_role" "workflow" {
  name               = "LakeFormationWorkflowRole"
  assume_role_policy = data.aws_iam_policy_document.workflow_assume.json

  description = "Allows Glue to call AWS services on your behalf"
}

# Trust Relationships

data "aws_iam_policy_document" "workflow_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    effect = "Allow"
  }
}

# Attached Policies

data "aws_iam_policy" "glue_service_role" {
  name = "AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "workflow_glue_service_role" {
  role       = aws_iam_role.workflow.name
  policy_arn = data.aws_iam_policy.glue_service_role.arn
}


# Inline Policies

data "aws_iam_policy_document" "workflow_lake_formation" {
  statement {
    effect = "Allow"
    actions = [
      "lakeformation:GetDataAccess",
      "lakeformation:GrantPermissions"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.workflow.arn]
  }
}


resource "aws_iam_role_policy" "workflow_lake_formation" {
  name   = "LakeFormationWorkflow"
  role   = aws_iam_role.workflow.id
  policy = data.aws_iam_policy_document.workflow_lake_formation.json
}
