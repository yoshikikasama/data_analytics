import json


def hello(event, context):
    try:

        body = {
            "message": "Go Serverless v1.0! Your function executed successfully!",
            "input": event
        }

        response = {
            "statusCode": 200,
            "body": json.dumps(body)
        }
        return response
    except Exception as e:
        raise {
            "statusCode": 500,
            "body": e
        }
