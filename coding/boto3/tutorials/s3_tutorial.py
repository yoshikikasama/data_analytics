import boto3

s3 = boto3.resource('s3')

for bucket in s3.buckets.all():
    print(bucket.name)

# upload a new file
data = open('dog.jpg', 'rb')
s3.Bucket(bucket.name).put_object(Key='dog.jpg', Body=data)