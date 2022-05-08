"""
あやめデータセットの可視化
"""
from sklearn.datasets import load_iris
import pandas as pd
import matplotlib.pyplot as plt

iris = load_iris()
iris_df = pd.DataFrame(iris.data, columns=iris.feature_names)
iris_df['target'] = iris.target
# print(iris.target_names)
# print(iris_df)
# targetごとの平均値を求める
# print(iris_df.groupby('target').mean())

# 可視化
color_map = ['b', 'r', 'g']
for target, target_name in enumerate(iris.target_names):
    target_iris_df = iris_df[iris_df.target == target]
    plt.scatter(
        target_iris_df['petal length (cm)'],
        target_iris_df['petal width (cm)'],
        label=target_name,
        c=color_map[target]
    )
plt.show()