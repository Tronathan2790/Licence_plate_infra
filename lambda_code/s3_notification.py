import os
import boto3
import json
SQS_QUEUE_NAME = os.environ["SQS_QUEUE_NAME"]
def lambda_handler(event,context):
    record = event["Records"][0]
    s3_record = record["s3"]
    bucket_name = s3_record["bucket"]["name"]
    key_name = s3_record["object"]["key"]
    uuid = key_name.split('/')[1]
    print(f"Bucket: {bucket_name} Key: {key_name} Identitfier: {uuid}")

    sqs = boto3.resource('sqs')
    message = {
    "bucket_name": bucket_name,
    "Key": key_name,
    "uuid": uuid
    }
    queue = sqs.get_queue_by_name(QueueName=SQS_QUEUE_URL)
    response = queue.send_message(MessageBody=json.dumps(message))
    print(response.get('MessageId'))
    print(response.get('MD5OfMessageBody'))