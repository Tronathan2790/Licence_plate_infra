terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

   cloud { 
    
    organization = "tronathan2790-org" 

    workspaces { 
      name = "Github-Actions" 
    } 
  } 
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-2"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "licence_plate_bucket" {
  bucket = "licence-plate-bucket-${random_id.bucket_suffix.hex}"
  
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.licence_plate_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_notification_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "private/"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}