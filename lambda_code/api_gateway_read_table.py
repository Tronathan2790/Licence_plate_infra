import json
import boto3
import os
from boto3.dynamodb.conditions import Attr
DYNAMODB_TABLE_NAME = os.environ["DYNAMODB_TABLE_NAME"]

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DYNAMODB_TABLE_NAME)

def lambda_handler(event, context):
    owner_id = event['pathParameters']['id']

    response = table.scan(
        FilterExpression=Attr('uuid').eq(owner_id)
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps(response['Items']),
        'headers': {
            'Content-Type': 'application/json'
        }
    }