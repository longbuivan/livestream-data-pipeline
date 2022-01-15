#DynamoDB
resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "counting-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "Key"
  attribute {
    name = "Key"
    type = "S"
  }
}