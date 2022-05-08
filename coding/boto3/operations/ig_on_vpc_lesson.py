"""
VPC内にInternet GateWayをboto3で作成するコマンド
グローバルIP・・・インターネットからみて一意に特定できる
プライベートIP・・・内部で独自に振っている
ルーター・・・外と中を変換してくれるもの。ルーターは異なるネットワークをつなぐツール。
ネットワーク部・・・グローバル
ホスト部・・・個々のもの
サブネットマスク・・・ネットワーク部とホスト部を切り分けるもの。
CIDR表記・・・ネットワーク部を「/24」（1が24個）のような形で現したもの。「192.168.0.1/24」
VPC(Virtual Private Cloud)・・・仮想ネットワーク、プライベートなネットワーク空間
インターネットゲートウェイ・・・VPCがインターネットへ接続するための出入り口。
aws s3 ls s3://bucket
    コマンド サブコマンド 引数
"""
import boto3
import pprint
client = boto3.client('ec2')
response = client.create_vpc(
    CidrBlock="10.0.0.0/16",
)
vpc_id = response['Vpc']['VpcId']

response = client.create_internet_gateway()
igw_id = response['InternetGateway']["InternetGatewayId"]
response = client.attach_internet_gateway(
    InternetGatewayId=igw_id,
    VpcId=vpc_id
)
pprint.pprint(response)
