import json                                        #conver Python objects to JSON strings and back.
import uuid                                        #module used to generate unique identifiers.
import boto3                                       #Imports AWS SDK for Python.allows the Lambda function to interact with AWS services like DynamoDB.
import os                                          #allows access to environment variables
import logging                                     #module for logging messages (useful for debugging and monitoring in CloudWatch).

logger = logging.getLogger()                       #It gets the root logger object, which is used to write log messages (INFO, ERROR, etc.) that will be sent to the logging system (e.g., CloudWatch in AWS Lambda).
logger.setLevel(logging.INFO)                      #Sets the logging level to INFO

dynamodb = boto3.resource("dynamodb")              #Creates a DynamoDB resource object
TABLE_NAME = os.environ["TABLE_NAME"]              #Reads the TABLE_NAME environment variable.

def lambda_handler(event, context):
    logger.info(f"Incoming event: {json.dumps(event)}") #Logs the incoming event as a JSON string to CloudWatch Logs

    item = {
        "request_id": str(uuid.uuid4()),              #Generates a unique UUID and converts it to a string
        "request": json.dumps(event)                  #Converts the incoming event into a JSON string and stores it as the request payload.
    }

    table = dynamodb.Table(TABLE_NAME)                #Gets a reference to the DynamoDB table using the table name from environment variables
    table.put_item(Item=item)                         #Inserts the item into the DynamoDB table.

    return {
        "statusCode": 200,
        "body": json.dumps({
            "status": "healthy",
            "message": "Request processed and saved."
        })
    }
