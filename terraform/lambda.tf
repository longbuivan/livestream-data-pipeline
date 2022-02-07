####Lambda Function###
#Lambda package data
data "archive_file" "flatting_data" {
  type = "zip"
  source {
    content  = file("../src/flatting_data.py")
    filename = "src/flatting_data.py"
  }

  output_path = "./function.zip"

}

data "archive_file" "web_ingesting" {
  type = "zip"
  source {
    content  = file("../src/web_ingesting.py")
    filename = "src/web_ingesting.py"
  }

  output_path = "./web_ingesting.zip"

}
# Lambda Raw Data Ingesting

resource "aws_lambda_function" "web_raw_ingesting_lambda" {
  function_name    = "web_ingesting"
  filename         = "web_ingesting.zip"
  runtime          = "python3.8"
  handler          = "src/web_ingesting.lambda_handler"
  timeout          = "900"
  memory_size      = "128"
  source_code_hash = data.archive_file.flatting_data.output_base64sha256
  role             = aws_iam_role.LambdaExecution.arn

  environment {
    variables = {
      WEB_RAW_KINESIS = aws_kinesis_stream.web_raw_streaming.name
      RAW_STREAM_NAME = aws_kinesis_stream.web_raw_streaming.name
      WEB_ENDPOINT    = var.web_data_endpoint.name
    }
  }
}


#Lambda resource
resource "aws_lambda_function" "flatting_data" {
  function_name    = "flatting_data"
  filename         = "function.zip"
  runtime          = "python3.8"
  handler          = "src/flatting_data.lambda_handler"
  timeout          = "900"
  memory_size      = "128"
  source_code_hash = data.archive_file.flatting_data.output_base64sha256
  role             = aws_iam_role.LambdaExecution.arn
}

#Grant bucket-1 permission to trigger Lambda Function
resource "aws_lambda_permission" "allow_terraform_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.flatting_data.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket-1.arn
}

#Add s3 resource for invoking to lambda function
resource "aws_s3_bucket_notification" "bucket_terraform_notification" {
  bucket = aws_s3_bucket.bucket-1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.flatting_data.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_terraform_bucket]
}
