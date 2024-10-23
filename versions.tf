terraform {
  required_version = ">= 1.9.5"

  backend "s3" {
    bucket         = "sd-pipeline-php"
    key            = "terraform-ecs/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}