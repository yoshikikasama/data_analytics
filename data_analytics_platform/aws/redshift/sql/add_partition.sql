ALTER TABLE spectrum.category ADD PARTITION (year=2022,month=10,day=4) 
LOCATION 's3://kasama-dev/category/year=2022/month=10/day=04/';