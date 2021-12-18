awslocal lambda invoke --function-name terraform-example-lambda-function --payload file://payload.json out --log-type Tail --query LogResult --output text --cli-binary-format raw-in-base64-out
