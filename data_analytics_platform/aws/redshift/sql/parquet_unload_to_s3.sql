UNLOAD ('SELECT * FROM public.category')
TO 's3://kasama-dev/category/year=2022/month=10/day=02/'
FORMAT AS PARQUET
CREDENTIALS 'aws_iam_role=arn:aws:iam::068788852374:role/service-role/AmazonRedshift-CommandsAccessRole-20221002T182645';