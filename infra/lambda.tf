data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "example" {
  function_name    = "demo-lambda"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      ENV = "dev"
    }
  }
}
