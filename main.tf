# Public Cloud Configuration
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test123"
  secret_key                  = "testabc"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  endpoints {
    s3 = "http://localhost:4566"
    sqs = "http://localhost:4566"
    sns = "http://localhost:4566"
  }
}

# Create Bucket
resource "aws_s3_bucket" "b" {
  bucket = "onexlab-bucket-terraform"
  acl    = "public-read"
  tags = {
    Environment = "test"
  }
}

# Upload an object
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "test.txt"
  acl    = "public-read"
  source = "test.txt"
}

# Create Main Queue
resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform-example-queue"
  tags = {
    Environment = "test"
  }
}

# Create Dead Letter Queue