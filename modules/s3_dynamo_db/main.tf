resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
}

data "aws_dynamodb_table" "terraform_lock" {
  name = var.dynamodb_table_name
}