provider "aws" {
  region = ap-southeast-2
  # access_key = "AKIAWYIYEHRNL3KVS6NL"  # Your AWS Access Key
  # secret_key = "Ztwtqp0xis9CE4UcPvM3r7WIwuSLet/25upCYfVN"  # Your AWS Secret Key
}
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
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