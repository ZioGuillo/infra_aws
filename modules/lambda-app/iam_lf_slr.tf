# IAM role for workflows

resource "aws_iam_role" "dl_slr" {
  name               = "DataLake-ServiceRole"
  assume_role_policy = data.aws_iam_policy_document.dl_slr_assume.json

  description = "Data Lake Formation Service Role"
}

# Trust Relationships

data "aws_iam_policy_document" "dl_slr_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lakeformation.amazonaws.com",
        "glue.amazonaws.com",
      ]
    }

    effect = "Allow"
  }

}

# Inline Policies

# DL-S3 access
# Grant S3 access for DL service account

data "aws_iam_policy_document" "dl_slr_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.lambda_bucket.arn}/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.lambda_bucket.arn]
  }
}

resource "aws_iam_role_policy" "dl_slr_s3" {
  name   = "DLS3-${local.bucket_name}"
  role   = aws_iam_role.dl_slr.id
  policy = data.aws_iam_policy_document.dl_slr_s3.json
}

