"""データ変換処理
マッピング・・・ユーザーデータの性別を日本語にするなど。
ビン分割・・・年齢を10歳区切りで集計するなど

"""
# pandasを利用したデータの加工方法
import pandas as pd
import matplotlib.pyplot as plt

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

# ユーザーデータの英語を日本語にする
# print(user_df.head())
# print(user_df[' gender '].value_counts())
gender_map_table = {
    'F': '女性',
    'M': '男性',
}
# map関数
user_df['gender_ja'] = user_df[' gender '].map(gender_map_table)
# print(user_df.head())

# ビン分割
# 年齢を10歳区切りで集計したい
# user_df[' age '].value_counts().sort_index().plot(kind='bar')
# plt.show()

# 7~73歳をカバーできるように分割
age_bins = [0, 10, 20, 30, 40, 50, 60, 70, 80]
age_bins_data = pd.cut(user_df[' age '], age_bins)
age_bins_data.value_counts().sort_index().plot(kind='bar')
plt.show()