resource "aws_dynamodb_table" "licence_plate_table" {
  name           = "licence_plate_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "uuid"
  range_key      = "JobID"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "JobID"
    type = "S"
  }

  attribute {
    name = "StartTime"
    type = "S"
  }
   attribute {
    name = "EndTime"
    type = "S"
  }
  attribute {
    name = "LicencePlateNo"
    type = "S"
  }
  attribute {
    name = "State"
    type = "S"
  }
  attribute {
    name = "Status"
    type = "S"
  }
  
}