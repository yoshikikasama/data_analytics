create external table spectrum.category(
catid    smallint,
catgroup varchar(10),
catname  varchar(10),
catdesc  varchar(50)
)
PARTITIONED BY (year int, month int ,day int )
STORED as PARQUET
location 's3://kasama-dev/category/'
table properties ('compression_type'='snappy');