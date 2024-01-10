provider "aws" {
  region = "us-west-2"
  access_key = "AKIASXILRRYWIIXWYGIL"
  secret_key = "FirSxGkFPhuuTxM8IGf+18XTnyLcX5L19TgJoCJD"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example_subnet" {
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "example-subnet"
  }
}

resource "aws_instance" "example_instance" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example_subnet.id
  tags = {
    Name = "example-instance"
  }
  
  metadata_options {
    http_tokens = "required"
  }
  
  monitoring = true
}

resource "aws_flow_log" "example_flow_log" {
  depends_on = [
    aws_vpc.example_vpc,
    aws_instance.example_instance
  ]
  
  iam_role_arn      = aws_iam_role.example_role.arn
  log_destination   = "arn:aws:logs:us-west-2:123456789012:log-group:example-log-group"
  traffic_type      = "ALL"
  vpc_id            = aws_vpc.example_vpc.id
}

