resource "aws_dynamodb_table" "challenge" {
  name             = "linus-code-challenge"
  hash_key         = "id"
  billing_mode   = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  attribute {
    name = "id"
    type = "S"
  }
}

