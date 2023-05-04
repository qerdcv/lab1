terraform {
  backend "s3" {
    bucket         = "example-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "example-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "example-terraform-state-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "example-terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  attribute {
    name = "CreateDate"
    type = "S"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}