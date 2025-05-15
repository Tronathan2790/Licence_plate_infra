import boto3
import json

def lambda_handler(event,context):
    message = json.loads(event[0]['Body'])
    print(message)
    #test