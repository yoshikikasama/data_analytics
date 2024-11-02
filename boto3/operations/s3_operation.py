import os
import sys
import threading
import boto3
import json
from boto3.s3.transfer import TransferConfig


BUCKET_NAME = 'yoshiki-s3-2022-bucket'


def s3_client():
    s3 = boto3.client('s3')
    """ :type : pyboto3.s3 """
    return s3


def s3_resource():
    s3 = boto3.resource('s3')
    return s3


def create_bucket(bucket_name):
    return s3_client().create_bucket(
        Bucket=bucket_name,
        CreateBucketConfiguration={
            'LocationConstraint': 'ap-northeast-1'
        }
    )


def create_bucket_policy():
    # IAMポリシーでアクセスする許可と拒否の条件をJSON形式で記述したものがPolicyドキュメント
    bucket_policy = {
        # policy statementの現行version
        "Version": "2012-10-17",
        "Statement": [
            {
                # Statement ID(任意のID)
                "Sid": "AddPerm",
                # リソースへのアクセスを許可するには、Effect 要素を Allow に
                "Effect": "Allow",
                # ステートメントのアクションやリソースへのアクセスが許可されているアカウントまたはユーザー
                "Principal": {
                    "AWS": "arn:aws:iam::068788852374:user/yoshiki.kasama"
                },
                # s3に対する全てのactionを許可
                "Action": ["s3:*"],
                # ステートメントで取り扱う一連のオブジェクトを指定します。
                "Resource": ["arn:aws:s3:::yoshiki-s3-2022-bucket/*"]
            }
        ]
    }
    policy_string = json.dumps(bucket_policy)
    return s3_client().put_bucket_policy(
        Bucket=BUCKET_NAME,
        Policy=policy_string
    )


def list_buckets():
    return s3_client().list_buckets()


def get_bucket_policy():
    return s3_client().get_bucket_policy(Bucket=BUCKET_NAME)


def update_bucket_policy():
    bucket_policy = {
        # "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AddPerm",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                    's3:DeleteObject',
                    's3:GetObject',
                    's3:PutObject'
                ],
                "Resource": "arn:aws:s3:::" + BUCKET_NAME + "/*"
            }
        ]
    }
    policy_string = json.dumps(bucket_policy)
    return s3_client().put_bucket_policy(
        Bucket=BUCKET_NAME,
        Policy=policy_string
    )


def upload_small_file():
    file_path = "/Users/kasamayoshiki/Documents/tmp/classmethod/img/dog.jpg"
    return s3_client().upload_file(file_path, BUCKET_NAME, "dog.jpg")


def upload_large_file():
    config = TransferConfig(multipart_threshold=1024 * 25, max_concurrency=10,
                            multipart_chunksize=1024 * 25, use_threads=True)
    file_path = "/Users/kasamayoshiki/Documents/tmp/classmethod/img/eagle.jpg"
    key_path = "multipart_files/eagle.jpg"
    s3_resource().meta.client.upload_file(file_path, BUCKET_NAME, key_path,
                                          # 追加の引数
                                          ExtraArgs={
                                              'ACL': 'public-read',
                                              #   'contentType': 'text'
                                          },
                                          #   データの転送中に使用されるconfig
                                          Config=config,
                                          #   データの転送中に呼ばれる関数
                                          Callback=ProgressPercentage(file_path))


class ProgressPercentage():
    def __init__(self, filename):
        self._filename = filename
        self._size = float(os.path.getsize(filename))
        print(self._size)
        self._seen_so_far = 0
        self._lock = threading.Lock()

    def __call__(self, bytes_amout):
        with self._lock:
            self._seen_so_far += bytes_amout
            percentage = (self._seen_so_far / self._size) * 100
            sys.stdout.write(
                "\r%s  %s / %s  (%.2f%%)" % (
                    self._filename, self._seen_so_far, self._size, percentage
                )
            )
            sys.stdout.flush()


def read_object_from_bucket():
    object_key = "multipart_files/eagle.jpg"
    return s3_client().get_object(
        Bucket=BUCKET_NAME,
        Key=object_key
    )


def version_bucket_files():
    s3_client().put_bucket_versioning(
        Bucket=BUCKET_NAME,
        VersioningConfiguration={
            'Status': 'Enabled'
        }
    )


def upload_a_new_version():
    file_path = '/Users/kasamayoshiki/Documents/tmp/classmethod/img/eagle.jpg'
    return s3_client().upload_file(file_path,
                                   BUCKET_NAME,
                                   'multipart_files/eagle.jpg')


if __name__ == "__main__":
    # response = create_bucket(BUCKET_NAME)
    # response = create_bucket_policy()
    # response = list_buckets()
    # response = get_bucket_policy()
    # response = update_bucket_policy()
    # response = upload_small_file()
    # upload_large_file()
    # response = read_object_from_bucket()
    # print(response)
    # version_bucket_files()
    upload_a_new_version()
