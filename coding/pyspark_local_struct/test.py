# dockerで構築した場合
# コンソールで設定したSparkとNoteBookを接続します(動かす前に毎度実行する必要があります)
import findspark
findspark.init()


#pysparkに必要なライブラリを読み込む
import datetime
from pyspark import SparkConf
from pyspark import SparkContext
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, DateType, IntegerType
from pyspark.sql.functions import lit, when, udf, substring, col
from cryptography.fernet import Fernet
#spark sessionの作成
# spark.ui.enabled trueとするとSparkのGUI画面を確認することができます
# spark.eventLog.enabled true　とすると　GUIで実行ログを確認することができます
# GUIなどの確認は最後のセクションで説明を行います。
spark = SparkSession.builder \
    .appName("chapter1") \
    .config("hive.exec.dynamic.partition", "true") \
    .config("hive.exec.dynamic.partition.mode", "nonstrict") \
    .config("spark.sql.session.timeZone", "JST") \
    .config("spark.ui.enabled","true") \
    .config("spark.eventLog.enabled","true") \
    .enableHiveSupport() \
    .getOrCreate()

# spark.sql("show tables").show() 
# jsonデータの読み込み
# json_df = spark.read.json("./pyspark_super_crush_course/dataset/jinko.json")
# json_df.show(n=10)

# csvデータ読み込み
struct = StructType([
    StructField("code", StringType(), False),
    StructField("kenmei", StringType(), False),
    StructField("gengo", StringType(), False),
    StructField("wareki", StringType(), False),
    StructField("seireki", StringType(), False),
    StructField("chu", StringType(), False),
    StructField("sokei", StringType(), False),
    StructField("jinko_male", StringType(), False),
    StructField("jinko_female", StringType(), False),
    StructField("syain_bango", StringType(), False),
    StructField("nyusya_nengetu", StringType(), False),
    StructField("date_test", StringType(), False),
])
df_csv = spark.read.option("multiline", "true").option("encoding", "UTF-8") \
    .csv("jinko.csv", header=False, sep=',', inferSchema=False, schema=struct)
df_csv.show(truncate=False, n=4)
df_csv = df_csv.filter(df_csv['code'] != '都道府県コード')
# df_csv.show(truncate=False, n=4)
df_csv.withColumn("peke", when(df_csv.gengo == '大正', lit("2")) \
    .when(df_csv.gengo == '昭和', df_csv.wareki)).fillna({"peke":"a", "chu": "1"}).filter(df_csv.kenmei == '全国')
    # .when(df_csv.gengo == '昭和', df_csv.wareki).otherwise("99999")).filter(df_csv.kenmei == '全国').show(n=20)
def encrypt_columns(columns):
    # データを取り出して暗号化
    key = Fernet.generate_key()
    #データをバイトに変換する
    byte_data = columns.encode()
    f = Fernet(key)
    token = f.encrypt(byte_data)
    return token
def to_date_ch(nyusya_nengetu, format):
    try:
        datetime_type = datetime.datetime.strptime(nyusya_nengetu, format)
        return datetime_type.date()
    except:
        if '"' in nyusya_nengetu:
            nyusya_nengetu = nyusya_nengetu.replace('"', '')
        date_type = (datetime.datetime(1899,12,30) + datetime.timedelta(int(nyusya_nengetu)))
        print(date_type)
        print(type(date_type))
        return date_type.date()

def _cast_date(date_str, format):
    if date_str is not None and date_str != "":
        datetime_str = datetime.datetime.strptime(date_str, format)
        return datetime_str.date()
udf_encrypt_columns = udf(encrypt_columns)
udf_todate = udf(to_date_ch, DateType())
udf_date = udf(_cast_date, DateType())
df_csv = df_csv \
    .withColumn('Login_User_For_Join', udf_encrypt_columns(substring('syain_bango', 7, 6))) \
    .withColumn('syain_bango', udf_encrypt_columns('syain_bango')) \
    .withColumn('date_test', udf_date('date_test', lit("%Y/%m/%d"))) \
    .withColumn('nyusya_nengetu', udf_todate('nyusya_nengetu', lit("%Y/%m/%d")))

df_csv.show()
df_csv.printSchema()
# df_csv.select("code", "Login_User_For_Join", "kenmei","gengo", "wareki", "seireki", "chu", "sokei", "jinko_male", "jinko_female", "syain_bango").show()




spark.stop()
spark.sparkContext.stop()