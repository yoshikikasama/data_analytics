"""Paginator
list_objects_v2:オブジェクトの一覧を得るAPI
これを大量のファイルがあるバケット全体に対して呼び出した場合、
条件に合う最初の1000件が返ってくる
数万のオブジェクトがあるときでも安全に使えるようにする為、

それ以上のデータを取得したい場合は、
-自前でContinuation Tokenを取得・設定する
-Paginatorを使う(google検索で最初の10件を表示して、次へを押すと次の10件が表示される仕組みのこと)
"""
import boto3
import pprint

s3 = boto3.client("s3")


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
