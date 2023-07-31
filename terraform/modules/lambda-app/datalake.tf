# Data Lake Settings
resource "aws_lakeformation_data_lake_settings" "default" {
  admins = [aws_iam_role.dl_admin.arn]
}

resource "aws_lakeformation_resource" "default" {
  provider = aws.dl_admin

  arn      = aws_s3_bucket.lambda_bucket.arn
  role_arn = aws_iam_role.dl_slr.arn
}

resource "aws_glue_catalog_database" "dl_default" {
  provider = aws.dl_admin

  name         = "${var.environment}-${var.aws_region}-default"
  description  = "Default Data Lake for ${var.environment}-${var.aws_region}"
  location_uri = "s3://${aws_s3_bucket.lambda_bucket.bucket}/default/"
  parameters   = {}
}