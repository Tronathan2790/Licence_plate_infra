import datetime
import os
import uuid
import boto3
import json
SQS_QUEUE_NAME = os.environ["SQS_QUEUE_NAME"]
DYNAMODB_TABLE_NAME = os.environ["DYNAMODB_TABLE_NAME"]
def lambda_handler(event,context):
    record = event["Records"][0]
    s3_record = record["s3"]
    bucket_name = s3_record["bucket"]["name"]
    key_name = s3_record["object"]["key"]
    user_uuid = key_name.split('/')[1]
    print(f"Bucket: {bucket_name} Key: {key_name} Identitfier: {user_uuid}")

    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(DYNAMODB_TABLE_NAME)
    current_time = str(datetime.utcnow().isoformat())
    id = str(uuid.uuid4())
    item = {
        'JobID': id,
        'uuid': user_uuid,
        'StartTime': current_time,
        'TimeCompleted': "",
        'Licence_plate': "",
        'State': "",
        'Status':"Processing"
    }
    table.put_item(Item=item)
    print(f"✅ Saved to DynamoDB: {item}")


    sqs = boto3.resource('sqs')
    message = {
    "bucket_name": bucket_name,
    "Key": key_name,
    "uuid": uuid
    }
    queue = sqs.get_queue_by_name(QueueName=SQS_QUEUE_NAME)
    response = queue.send_message(MessageBody=json.dumps(message))
    print(response.get('MessageId'))
    print(response.get('MD5OfMessageBody'))