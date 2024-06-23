provider "aws" {
  region                   = var.region
  shared_credentials_files = ["../credentials"]
  profile                  = "default"
}

# Lambda function resource
resource "aws_lambda_function" "greet_lambda" {
  filename      = "lambda.zip"  # Lambda deployment package (zip file)
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec_role.arn  # IAM role ARN for Lambda execution
  handler       = "lambda.lambda_handler"  # Name of the function and the handler function
  runtime       = "python3.8"  # Lambda runtime

  # Environment variables (optional)
  environment {
    variables = {
      greeting = "Hello world!"
    }
  }
}

# IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM policy attachment for Lambda execution role (allow logging)
resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Package the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}"
  output_path = "${path.module}/lambda.zip"
  depends_on  = [aws_iam_role_policy_attachment.lambda_exec_attach]
}

# Output the Lambda function ARN
output "lambda_function_arn" {
  value = aws_lambda_function.lambda_function.arn
}
