provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Project     = "Internship Program"
      Environment = "Dev"
      Owner       = "Silvio Depetri"
      CostCenter  = ""
    }
  }
}