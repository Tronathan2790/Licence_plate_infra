

resource "aws_lambda_function" "s3_notification_function" {
  filename      = "lambda_code.zip"
  function_name = "s3_notification_function"
  role          = aws_iam_role.iam_for_s3_lambda.arn
  handler       = "s3_notification.lambda_handler"
  runtime       = "python3.10"
  source_code_hash = filebase64sha256("lambda_code.zip")
  timeout = 900
  environment {
    variables = {
      SQS_QUEUE_NAME = aws_sqs_queue.licence_plate_queue.name
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.licence_plate_table.name
    }
  }
}