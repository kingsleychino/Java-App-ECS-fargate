provider "aws" {
  region = "us-east-1"
}

//1. VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "ecs-vpc" }
}


//2. Subnet
resource "aws_subnet" "public-subnet-a" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "ecs-public-subnet-a" }
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "ecs-public-subnet-b" }
}


//3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev-vpc.id
}


//4. Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


//5. Association Route Table
resource "aws_route_table_association" "public-rt-ass-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rt-ass-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-rt.id
}