data "aws_vpc" "internship_vpc" {
  id = "vpc-01fc1ec68a8b03eb9"
}

data "aws_subnet" "public_subnet_1" {
  id = "subnet-0d4b3436fdda9803f"
}

data "aws_subnet" "public_subnet_2" {
  id = "subnet-09d1848907ea68bca"
}

data "aws_subnet" "private_subnet_1" {
  id = "subnet-0d5a03c63e1d24a17"
}

data "aws_subnet" "private_subnet_2" {
  id = "subnet-00ec5ce7c1e376323"
}

output "vpc_id" {
  value = data.aws_vpc.internship_vpc.id
}

output "public_subnets" {
  value = [data.aws_subnet.public_subnet_1.id, data.aws_subnet.public_subnet_2.id]
}

output "private_subnets" {
  value = [data.aws_subnet.private_subnet_1.id, data.aws_subnet.private_subnet_2.id]
}