"""
PythonでS3上の画像やCSVデータを直接メモリに展開して読み書きする方法
"""
import io
import boto3
import io
from PIL import Image

s3_client = boto3.client("s3")

# object data get
s3_object = s3_client.get_object(
    Bucket="net-ykasama-test2022", Key="dog.jpg"
)
# byte data read
image_data = io.BytesIO(s3_object['Body'].read())

# change the picture
pil_image = Image.open(image_data)
# 保存領域を用意
buf = io.BytesIO()

# 用意したメモリに保存
pil_image.save(buf, "JPEG")

# byteデータをアップロード
s3_client.put_object(
    Bucket="net-ykasama-test2022",
    Key="dog_tesst.jpg",
    Body=buf.getvalue()
)

response = s3_client.list_objects(
    Bucket="net-ykasama-test2022"
)
for content in response['Contents']:
    print(f"{content['Key']}: {content['Size']}")
