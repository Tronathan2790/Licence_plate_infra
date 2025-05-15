data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_s3_lambda" {
  name               = "iam_for_s3_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_notification_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.licence_plate_bucket.arn
}

 resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
     role       = aws_iam_role.iam_for_s3_lambda.name
     policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
   }