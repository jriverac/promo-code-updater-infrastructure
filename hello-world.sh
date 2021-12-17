awslocal sns publish --topic-arn arn:aws:sns:us-east-1:000000000000:terraform-example-topic-first --message "Hello World"

awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/terraform-example-queue --max-number-of-messages 10