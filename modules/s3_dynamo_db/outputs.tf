output "bucket_name" {
  description = "Name of the S3 bucket used for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "Name of the existing DynamoDB table for state locking"
  value       = data.aws_dynamodb_table.terraform_lock.id
}