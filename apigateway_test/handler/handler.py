import json


class LambdaException(Exception):
    def __init__(self, status_code: int, error_msg: str):
        self.status_code = status_code
        self.error_msg = error_msg

    def __str__(self):
        obj = {
           'Status': self.status_code,
            'ErrorReason': self.error_msg
        }
        return json.dumps(obj)


class BadRequestException(LambdaException):
    def __init__(self, error_msg: str):
        super().__init__(404, error_msg)


class InternalServerErrorException(LambdaException):
    def __init__(self, error_msg: str):
        super().__init__(500, error_msg)


def lambda_handler(event, context):
    # TODO implement
    try:
        # ERROR!
        hoge
        print('test')
        return {
            'Status' : 200, 
            'body'       : json.dumps({'Status' : '200', 'ErrorReason' : 'None'})
        }
    except Exception as e:
        raise InternalServerErrorException(str(e))