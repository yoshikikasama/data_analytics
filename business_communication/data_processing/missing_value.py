"""欠損値の処理
欠損値・・・Nanなどで表現される「存在しない」ことを表す数値
  　　　　　以下に紹介するような「除外」や「穴埋め」といった方法で対処する
"""
# pandasを利用したデータの加工方法
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

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

merged_df = pd.merge(left_table, right_table, on='user id ', how='left')
# print(merged_df.head())

# 欠損値を除外する
# print('全ての行', merged_df.shape[0])
# print('欠損値を一つでも含む行を除外', merged_df.dropna().shape[0])

# 欠損値を穴埋めする
# 欠損値を埋める前
print('欠損値処理をする前:', merged_df[' gender '].value_counts())
print('欠損値処理をした後:', merged_df[' gender '].fillna('性別データなし').value_counts())

# 年齢の欠損値についてその平均値で穴埋めする
print(merged_df[' age '].fillna(merged_df[' age '].mean()))
