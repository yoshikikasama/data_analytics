"""
Seriesオブジェクト・・・一次元配列(data,index(値の指定ができる),dtype,copy,name)
DataFrame・・・二次元配列(data,index,columns,dtype,copy)
"""
from turtle import title
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from sqlalchemy import column

datas_path = "/Users/kasamayoshiki/Documents/tmp/datas"
train = pd.read_csv(datas_path + "/case1/train.csv")
test = pd.read_csv(datas_path + "/case1/test.csv")
sample = pd.read_csv(datas_path + "/case1/sample.csv", header=None)

# カラム名の変更
print(train.rename(columns={'temperature': '気温'}))
# map関数で小数点の調整
print(train['temperature'].map('{:.2f}'.format))

# head() 先頭5行分を読み込む関数
# print(train.head(10))
# tail() 後ろ5行分を読み込む関数
# print(train.tail())
# 行数と列数を確認したい場合(行、列)
# print(train.shape)
# print(sample.head())
# 基本統計量を確認
# print(train.describe())
#                           y     soldout        kcal  payday  temperature
# count(何個値が入っているか)  207.000000  207.000000  166.000000    10.0   207.000000
# mean(平均値)               86.623188    0.449275  404.409639     1.0    19.252174
# std(標準偏差)              32.882448    0.498626   29.884641     0.0     8.611365
# min(最小値)                29.000000    0.000000  315.000000     1.0     1.200000
# 25%                       57.000000    0.000000  386.000000     1.0    11.550000
# 50%(中央値)                78.000000    0.000000  408.500000     1.0    19.800000
# 75%                       113.000000    1.000000  426.000000     1.0    26.100000
# max(最大値)                171.000000    1.000000  462.000000     1.0    34.600000

# データの型の確認
# print(train.info())
# #   Column         Non-Null Count  Dtype  
# ---  ------         --------------  -----  
#  0   datetime       207 non-null    object (文字列)
#  1   y              207 non-null    int64  
#  2   week           207 non-null    object 
#  3   soldout        207 non-null    int64  
#  4   name           207 non-null    object 
#  5   kcal           166 non-null    float64
#  6   remarks        21 non-null     object 
#  7   event          14 non-null     object 
#  8   payday         10 non-null     float64
#  9   weather        207 non-null    object 
#  10  precipitation  207 non-null    object 
#  11  temperature    207 non-null    float64
# dtypes: float64(3), int64(2), object(7)

# 1つのカラムにだけ注目
# print(train['y'])
# yの平均値、中央値
# print(train['y'].mean())
# print(train['y'].median())
# yの値が150以上のデータのみ
# print(train[train['y'] >= 150])
# 曜日が月曜日のデータ
# print(train[train['week'] == '月'])
# 曜日が火曜日となっているデータをyで昇順・降順にする
# print(train[train['week'] == '火'].sort_values(by='y'))
# print(train[train['week'] == '火'].sort_values(by='y', ascending=False))
# 曜日が月曜日の時のyの平均値
# print(train[train['week'] == '月']['y'].mean())
# trainのtemperatureが平均以上のデータ
# print(train[train['temperature'] >= train['temperature'].mean()])
# yとweek2つのカラムの選択
# print(train[['y', 'week']])

# trainのyの折れ線ブラフ
# ax = train['y'].plot(figsize=(12, 4), title='graph')
# ax.set_xlabel('time')
# ax.set_ylabel('y')
# plt.show()

# ヒストグラム
# 横軸の階級・・・数値の幅がどれくらいなのか
# 縦軸の度数・・・数値の範囲がどれくらい該当するものがあるのか
# train['y'].plot.hist(grid=True)
# plt.axvline(x=train['y'].mean(), color='red')
# train['y'].plot.hist(figsize=(12, 4), title='histgram')
# plt.savefig('sample_fig.png')
# plt.show()

# 箱ひげ図
# データ分布を確認するための図
# 上側ヒンジ・・・「中央値以上の値」の中央値
# 下側ヒンジ・・・「中央値以下の値」の中央値
# train[['y', 'week']].boxplot(by='week')
# plt.show()

# trainのtemperatureの折れ線グラフ。
# ax = train['temperature'].plot(title='temperature')
# ax.set_xlabel('time')
# ax.set_ylabel('temperature')
# plt.show()

# 欠損値・・・何らかの理由でデータの値が入っていない状態のこと
# isnullで欠損の有無を出す
# print(train.isnull())
# 各カラムに欠損値が1つ以上あるかないかを確かめる
# print(train.isnull().any())
# 各カラムに欠損値がいくつあるかを確かめる
# print(train.isnull().sum())

# 欠損値の処理方法・・・何らかの値を代入、欠損値を含む行を削除
# 欠損値を0で補完
# print(train.fillna(0))
# ある列に欠損値があった場合のみ、その行を削除
# print(train.dropna(subset=['kcal']))
# 行の値がそれぞれいくつあるかを確認
# print(train['precipitation'].value_counts())

# 正の相関・・・一方が上がるともう片方も上がる
# 負の相関・・・一方が上がるともう片方が下がる
# corr()で相関係数を算出,1に近いほど度合いが強い、0に近いほど度合いは弱い
# print(train[['y', 'temperature']].corr())
# print(train[['y', 'kcal']].corr())

# 散布図はplot.scatter関数を使う
# train.plot.scatter(x='temperature', y='y', figsize=(5,5))
# plt.show()

# csvへの書き込み aは追記
train.to_csv('test.csv', mode='w', index=False)