import boto3
import json

def lambda_handler(event,context):
    record = event["Records"][0]
    s3_record = record["s3"]
    bucket_name = s3_record["bucket"]["name"]
    key_name = s3_record["object"]["key"]
    identitfier = s3_record["bucket"]["ownerIdentity"]["principalId"]
    print(f"Bucket: {bucket_name} Key: {key_name} Identitfier: {identitfier}")
    #test