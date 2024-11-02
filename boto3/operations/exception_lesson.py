"""Exception
"""
import boto3
import sys
session = boto3.session.Session(region_name="ap-northeast-1")
s3 = session.client("s3")


def main():
    response = s3.delete_objects(
        Bucket="net-ykasama-test2022",
        Delete={
            "Objects": [
                {
                    "Key": "a.jpg"
                },
                {
                    "Key": "b.jpg"
                }
            ]
        }
    )
    print(response)
    # エラーの確認
    if response["ResponseMetadata"]["HTTPStatusCode"] != 200 and len(response["Errors"]) > 0:
        for err in response["Errors"]:
            # とりあえず、エラーの状況を標準エラー出力に出す
            print(err, file=sys.stderr)


if __name__ == "__main__":
    main()
