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
    iam = "http://localhost:4566"
    lambda = "http://localhost:4566"
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

# Create Role for Function
resource "aws_iam_role" "lambda_basic_execution" {
  name = "terraform-example-lambda-basic-execution"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create Function
resource "aws_lambda_function" "lambda_function" {
  filename      = "index.js.zip"
  function_name = "terraform-example-lambda-function"
  role          = aws_iam_role.lambda_basic_execution.arn
  handler       = "index.apiHandler"
  runtime       = "nodejs12.x"
  memory_size   = 128
  timeout       = 10
  publish       = true
  tags = {
    Environment = "test"
  }
}
