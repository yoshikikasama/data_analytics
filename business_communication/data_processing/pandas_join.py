"""データ収集・加工
ファイルデータ・・・何らかの形式で保存されたファイル(text,csv,jsonなどなど)
データベース・・・ストレージに格納されているデータを何らかの命令(SQLなど)で取得するアプリケーション
                MYSQL,Apache Hadoop, BigQuery, Redshift
データウェアハウス(DWH)・・・企業内の様々なファイル・DBが統合されたシステム。
SQL・・・DBを利用するための言語

データの結合(JOIN)・・・複数のtableを特定のIDに基づいて繋げること。
評価情報だけ見てもどのようなユーザーが評価をしているかわからないので、データを結合することで
よりわかりやすい分析をすることができる

結合の種類
AとBの2つのテーブルがある場合にAをLEFT,BをRIGHTと表現して以下のように結合の種類が使われる
- INNER_JOIN・・・両tableに同じkeyが存在するときに結合
- FULL JOIN(OUTER JOIN)・・・どちらかにキーが存在すれば結合、存在しない値はNoneで補完される。
- LEFT JOIN・・・Aにキーが存在する場合に結合
- RIGHT JOIN・・・Bにキーが存在する場合に結合

"""

# pandasを利用したデータの加工方法
import pandas as pd

# movieのユーザー評価情報、ユーザー情報を抽出
# ユーザー情報
user_url = 'https://files.grouplens.org/datasets/movielens/ml-100k/u.user'
user_df = pd.read_csv(user_url, sep='|', header=None, encoding='latin-1')
user_col_info = 'user id | age | gender | occupation | zip code'
user_df.columns = user_col_info.split('|')
# print(user_df)

# 評価情報
rating_url = 'https://files.grouplens.org/datasets/movielens/ml-100k/u.data'
rating_df = pd.read_csv(rating_url, sep='\t', header=None, encoding='latin-1')
rating_col_info = 'user id | item id | rating | timestamp'
rating_df.columns = rating_col_info.split('|')
# print(rating_df)

# INNER_JOIN
left_table = rating_df.sample(100, random_state=0)
right_table = user_df.sample(500, random_state=0)
# merged_df = pd.merge(left_table, right_table, on='user id ')
# print(left_table.head())
# print(right_table.head())
# print(merged_df.head())

# FULL_JOIN(OUTER JOIN)
merged_df = pd.merge(left_table, right_table, on='user id ', how='outer')
# print(merged_df.head())

# LEFT_JOIN
merged_df = pd.merge(left_table, right_table, on='user id ', how='left')
# print(merged_df.head())
# print(merged_df.shape)

# RIGHT_JOIN
merged_df = pd.merge(left_table, right_table, on='user id ', how='right')
# print(merged_df.head())
# print(merged_df.shape)
# print(merged_df['user id '].value_counts())
