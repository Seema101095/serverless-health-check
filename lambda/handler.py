import json
import uuid
import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource("dynamodb")
TABLE_NAME = os.environ["TABLE_NAME"]

def lambda_handler(event, context):
    logger.info(f"Incoming event: {json.dumps(event)}")

    item = {
        "request_id": str(uuid.uuid4()),
        "request": json.dumps(event)
    }

    table = dynamodb.Table(TABLE_NAME)
    table.put_item(Item=item)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "status": "healthy",
            "message": "Request processed and saved."
        })
    }
