provider "aws" {
  region                   = var.region
  shared_credentials_files = ["../credentials"]
  profile                  = "default"
}


# IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda_exec_role"
  assume_role_policy = jsonencode({
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
  })
}


# IAM policy attachment for Lambda execution role (allow logging)
resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Lambda function resource
resource "aws_lambda_function" "greet_lambda" {
  filename      = var.output_file_name
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  # Environment variables (optional)
  environment {
    variables = {
      greeting = "Hello world!"
    }
  }
}


# Package the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}"
  output_path = "${path.module}/lambda.zip"
  depends_on  = [aws_iam_role_policy_attachment.lambda_exec_attach]
}