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

resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = "LambdaSQSSendMessagePolicy"
  description = "Allows Lambda to send messages to SQS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sqs:SendMessage"
        ],
        Effect   = "Allow",
        Resource = aws_sqs_queue.licence_plate_queue.arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_attach" {
  role       = aws_iam_role.iam_for_s3_lambda.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}

resource "aws_iam_policy" "lambda_dynamo_policy" {
  name        = "LambdaDynamoDBScopedAccess"
  description = "IAM policy for Lambda to access a specific DynamoDB table"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = [
          aws_dynamodb_table.licence_plate_table.arn,
          "${aws_dynamodb_table.licence_plate_table.arn}/index/*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_Dynamo_attach" {
  role       = aws_iam_role.iam_for_s3_lambda.name
  policy_arn = aws_iam_policy.lambda_dynamo_policy.arn
}
data "aws_iam_policy_document" "keda_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:keda-sqs-reader"]
    }

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
    }
  }
}

resource "aws_iam_role" "keda_sqs_role" {
  name               = "keda-sqs-role"
  assume_role_policy = data.aws_iam_policy_document.keda_assume_role.json
}

resource "aws_iam_role_policy" "keda_sqs_access" {
  name = "keda-sqs-access"
  role = aws_iam_role.keda_sqs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:ListQueues"
        ],
        Resource = aws_sqs_queue.licence_plate_queue.arn
      }
    ]
  })
}