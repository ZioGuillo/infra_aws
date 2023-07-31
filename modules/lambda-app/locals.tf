locals {
  bucket_name = "${var.environment}-${var.aws_region}-linus-challenge-${random_pet.bucket_name.id}"
  module_name = "lambda"
}