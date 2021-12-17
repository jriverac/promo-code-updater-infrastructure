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

# Create S3 Bucket
resource "aws_s3_bucket" "b" {
  bucket = "onexlab-bucket-terraform"
  acl    = "public-read"
  tags = {
    Environment = "test"
  }
}

# Upload an object to S3 Bucket
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
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount = 4
  })
}

# Create Dead Letter Queue
resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name                      = "terraform-example-dead-letter-queue"
  tags = {
    Environment = "test"
  }
}

# Create First Topic
resource "aws_sns_topic" "first_topic" {
  name = "terraform-example-topic-first"
  tags = {
    Environment = "test"
  }
}

# Create First Topic Subscription
resource "aws_sns_topic_subscription" "first_topic_subscription" {
  topic_arn = aws_sns_topic.first_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.terraform_queue.arn
}
