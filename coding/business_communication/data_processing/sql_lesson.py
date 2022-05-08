"""データベース操作(SQL)
database(application)・・・データを効率よく使うためのアプリケーション
database(applicationの中のデータのかたまり)・・・アプリケーションで用いる表データのまとまり
table・・・個々の表データ(pandasのデータフレームに相当)
column・・・デーブルの各列

"""
import pandas as pd
from pandasql import sqldf

# movieのユーザー評価情報、ユーザー情報を抽出
# ユーザー情報
user_url = 'https://files.grouplens.org/datasets/movielens/ml-100k/u.user'
user_df = pd.read_csv(user_url, sep='|', header=None, encoding='latin-1')
user_col_info = 'user_id|age|gender|occupation|zip_code'
user_df.columns = user_col_info.split('|')
# print(user_df)

# 評価情報
rating_url = 'https://files.grouplens.org/datasets/movielens/ml-100k/u.data'
rating_df = pd.read_csv(rating_url, sep='\t', header=None, encoding='latin-1')
rating_col_info = 'user_id|item_id|rating|timestamp'
rating_df.columns = rating_col_info.split('|')
# print(rating_df)


# SQLの基本
def get_from_sql(sql_query):
    return_df = sqldf(sql_query)
    print('shape:', return_df.shape)
    return return_df.head()


# select文
query = 'select * from user_df'
# print(get_from_sql(query))

# カラム選択/limitで所得データの行数を絞り込む
query = """
select
 user_id, age
from user_df
limit 2
"""

# whereによる絞り込み
# 20歳のユーザーに限定して所得
query = """
select
*
from user_df
where
 age = 24
"""
# print(get_from_sql(query))

# 20際以下かつ男性のユーザー
query = """
select
*
from user_df
where
 age <= 20 and gender = 'M'
"""
# print(get_from_sql(query))

# orderbyを用いることで並び替えができる
# 学生ユーザーについて年齢順に並び替える
query = """
select
*
from user_df
where
 occupation = 'student'
 order by
 age asc
"""
# print(get_from_sql(query))

# 集約関数
# count・・・columnの行数を数える/もしくは全ての列についての行を数える
query = 'select count(*) from user_df'
# print(get_from_sql(query))

# 平均の年齢を求める
query = 'select avg(age) from user_df'
# print(get_from_sql(query))

# groupbyによる対象ごとの集約値
# asを用いると列名の変更ができる
query = """
select
 occupation, avg(age) as avg_age
 from
 user_df
 group by occupation

"""
# print(get_from_sql(query))

# havingを用いると集計後の値で絞り込むことができる
query = """
select
 occupation, avg(age) as avg_age
 from
 user_df
 group by occupation
 having
 avg_age < 30
 order by avg_age asc
"""
# print(get_from_sql(query))

# groupbyは二つ以上のカラムを指定できる
query = """
select
 occupation, avg(age) as avg_age, gender
 from
 user_df
 group by occupation, gender
 having
 avg_age < 30
 order by avg_age asc
"""
# print(get_from_sql(query))

# table join
# innner join
query = """
select
 *
 from
 user_df
 inner join rating_df
 on user_df.user_id = rating_df.user_id
"""
print(get_from_sql(query))