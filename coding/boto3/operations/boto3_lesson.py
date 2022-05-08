"""Memo
# clientとresourceは最終的にやれることは同じ
# 傾向としてはclientは単機能・resourceは親切
# clientで済むならなるべくclientで済ませた方がいい

# S3（Simple Storage Service）クラウド上でファイルを保存するためのサービス。
# システム開発で使いやすいようになっている
# APIを通じてファイルをやりとり、サイズ上限はなく、保存したデータ量に応じた課金
# S3の用途
# ・データ置き場
# ユーザーがアップロードした画像や動画を置いておく
# 機械学習用のデータを置いておく
# ・HTMLを置いて、webページをホスティングする（HTML + 画像などを置く）

# boto3 ドキュメントの読み方
# 1. まずはClientのメソッド一覧でざっくり把握
#  list, describe_, get_ あたりは情報をとってくる系
#   set_, put_, create_, update_あたりは設定する系
# 2. 各メソッドの説明はrequest, responseの順(responseはないこともある)
# 3. あまり使わない設定の説明も細かく書いてあるので全部理解できなくてもいい。
# 4. 困ったらサービス自体のドキュメントを読みにいくのも一手。
# Amazon Rekognition・・・AWSが提供する画像分析系のAIサービス

"""
import boto3
import pprint


def main():
    # clientの呼び出し方
    s3 = boto3.client("s3")
    rekognition = boto3.client("rekognition")
    bucket_name = "net-ykasama-test2022"
    # 利用したいサービスの呼び出し
    response = s3.list_objects_v2(
        Bucket=bucket_name
    )
    # それぞれのファイルに対してラベル検出を実行
    for r in response["Contents"]:
        k = r["Key"]
        print(k)

        labels = rekognition.detect_labels(
            Image={
                "S3Object": {
                    "Bucket": bucket_name,
                    "Name": k
                }
            }
        )
        pprint.pprint(labels)



    # # resourceでの呼び出し方
    # s3 = boto3.resource("s3")

    # # bucketをobjectとして扱うことができる
    # bucket = s3.Bucket("my-bucket-name")
    # objects = bucket.objects


if __name__ == "__main__":
    main()
