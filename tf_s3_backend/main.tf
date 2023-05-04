provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "example-terraform-state-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "example-terraform-locks"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

terraform {
  backend "s3" {
    bucket         = "example-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "example-terraform-locks"
    encrypt        = true
  }
}
