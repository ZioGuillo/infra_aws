import boto3 
import json
import uuid

def lambda_handler(event, context):
    print(event)
    
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('linus-code-challenge')
    
    response = table.put_item(Item={
        'id': str(uuid.uuid4()),
        'Email': 'pcisnerp@gmail.com',
        'RequestEventData': event
    })

    return {"statusCode": 200, "body": json.dumps(event)}



