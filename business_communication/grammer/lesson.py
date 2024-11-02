"""data analytics

データサイエンス・・・データから有用な情報・知識を引き出すための基本原理
データマイニング・・・データサイエンスに基づく方法を活用して、データから有用な情報、
　　　　　　　　　　　知識を引き出す方法論の集合
CRISP-DM(CRISPデータマイニングプロセス)・・・データマイニングにおける標準プロセスの一つ。
                   プロジェクトでDMを用いる際の効果的なプロセスを明示している。
データ分析・・・データから価値を見出すさまざまな手法またはその組み合わせ。
　　　　　　　　データマイニングはその手法の一つ。

numpy ・・・科学計算で用いられるライブラリ。多次元配列を高速に処理できる。
pandas・・・表データを扱うライブラリ。分析や機械学習の前処理などが簡単にできる。
matplotlib・・・データ可視化のためのpythonパッケージ。
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# ベクトル(1次元配列)の作成
# data = np.array([1, 2, 3, 4, 5])
# print(data)
# 要素数
# print(data.size)
# 内積(1*1 + 2*2 + 3*3 + 4*4 + 5*5)
# print(np.dot(data, data))
# 行列(2次元配列)matrix
# data = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
# matrix = data.reshape(3, 3)
# print(matrix)

# PandasのSeriesオブジェクト
# data = pd.Series([1, 2, 3, 4, 5])
# data = pd.Series(
#     [1, 2, 3, 4, 5],
#     index=['a', 'b', 'c', 'd', 'e']
# )
# print(data)
# PandasのDataFrameオブジェクト
# 表データのオブジェクト、列がseriesオブジェクト
# sample_df = pd.DataFrame(
#     {
#         'id': [10, 20, 30, 40, 50],
#         'name': ['Saito', 'Kato', 'Suzuki', 'Tanaka', 'Ito'],
#         'age': [22, 30, 25, 22, 30],
#         'address': ['tokyo', 'kanagawa', 'tokyo', 'tokyo', 'kanagawa']
#     }
# )
# print(sample_df)
# print(sample_df[['age', 'name']])
# データの抽出・並び替え
# print(sample_df[sample_df.age > 25])
# print(sample_df[sample_df.address == 'tokyo'])
# print(sample_df.sort_values(by='age'))

# 要素の個数をcount
# print(sample_df.address.value_counts())
# 各種統計量 max medium min　などなど
# print(sample_df.age.max())
# 集約
# grouped = sample_df.groupby('address')
# print(grouped[['age']].mean())
# print(grouped[['name']].count())


# matplotlib
# データ生成
# 0〜10までの間を100の間隔に切った数列を作成
x = np.linspace(0, 10, 100)

# それにランダムな値を足していく
y = x + np.random.randn(100)
# plt.plot(x, y)
# plt.show()

# 散布図
plt.scatter(x, y)
plt.show()