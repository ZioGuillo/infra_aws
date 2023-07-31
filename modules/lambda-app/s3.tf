resource "random_pet" "bucket_name" {}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = local.bucket_name

  force_destroy = true

  tags = {
    Name = local.bucket_name
  }

}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_bucket_enc" {
  bucket = local.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = local.bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}

data "archive_file" "write_to_dynamo" {
  type = "zip"

  source_dir  = "${path.module}/write-to-dynamo"
  output_path = "${path.module}/write-to-dynamo.zip"
}

resource "aws_s3_bucket_object" "write_to_dynamo" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "write_to_dynamo.zip"
  source = data.archive_file.write_to_dynamo.output_path

  etag = filemd5(data.archive_file.write_to_dynamo.output_path)
}
