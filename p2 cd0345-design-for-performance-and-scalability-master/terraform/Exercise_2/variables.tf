# TODO: Define the variable for aws_region
variable "region" {
    default = "us-east-1"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "greet_lambda"
}

variable "source_file" {
  type    = string
  default = "greet_lambda.py"
}

variable "output_file_name" {
  type    = string
  default = "greet_lambda.zip"
}

variable "lambda_function_name" {
  type    = string
  default = "greet_lambda"
}

variable "lambda_handler" {
  type    = string
  default = "greet_lambda.lambda_handler"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.8"
}