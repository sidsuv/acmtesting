provider "aws" {
  region = var.region
  # access_key = "AKIAWYIYEHRNL3KVS6NL"  # Your AWS Access Key
  # secret_key = "Ztwtqp0xis9CE4UcPvM3r7WIwuSLet/25upCYfVN"  # Your AWS Secret Key
}
terraform {
  backend "remote" {
    organization = "sidterraorg"

    workspaces {
      name = "acmtesting"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# resource "aws_eip" "nat" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id

#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }
# }

# resource "aws_route_table_association" "private" {
#   count          = length(aws_subnet.private)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public" {
  count                  = length(aws_subnet.public)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[count.index].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "public-instance-${count.index + 1}"
  }
}

resource "aws_instance" "private" {
  count                  = length(aws_subnet.private)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[count.index].id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}