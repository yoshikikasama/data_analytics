"""Session
AWSへの接続に必要な認証などの情報を設定するときに使う

これまでのboto3.client("s3")の中身は、
boto3._get_default_session().client("s3")と、
デフォルトで作られているSessionが使われる
この場合、aws-cliの設定である~/.aws/credentials, ~/.aws/configの"default"設定が利用される
Sessionの設定内容は環境変数でも指定できるので、そちらで設定するのがおすすめ
region_name: AWS_DEFAULT_REGION
profile_name: AWS_PROFILE

環境変数の設定
export AWS_DEFAULT_REGION=ap-northeast-1
"""
import boto3
import pprint
session = boto3.session.Session(region_name="ap-northeast-1")
s3 = session.client("s3")


def list_s3_files(bucket):
    paginator = s3.get_paginator("list_objects_v2")
    # Prefix:頭文字を指定して値を取得できる
    response_iterator = paginator.paginate(Bucket=bucket)
    results = []
    for response in response_iterator:
        pprint.pprint(response)
        for x in response["Contents"]:
            results.append(x["Key"])
    return results


def main():
    results = list_s3_files("net-ykasama-test2022")
    print(results)


if __name__ == "__main__":
    main()
