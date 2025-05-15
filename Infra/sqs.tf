resource "aws_sqs_queue" "licence_plate_queue" {
  name                      = "licence_plate_queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30
  

  
}