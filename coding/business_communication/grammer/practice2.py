"""
ワインデータの分析
"""
from sklearn.datasets import load_wine
import pandas as pd
import matplotlib.pyplot as plt

wine = load_wine()
wine_df = pd.DataFrame(wine.data, columns=wine.feature_names)
wine_df['target'] = wine.target
# print(wine_df.target.value_counts())
# wine_df.groupby('target').mean().T.plot(kind='bar')
# print(wine_df.columns)
# wine_df[['alcohol', 'malic_acid', 'ash', 'alcalinity_of_ash',
#          'total_phenols', 'flavanoids', 'nonflavanoid_phenols',
#          'proanthocyanins', 'color_intensity', 'hue',
#          'od280/od315_of_diluted_wines', 'target']].groupby('target').mean().T.plot(kind='bar')
# データの差分があるものだけを抽出
wine_df[['total_phenols', 'flavanoids', 'proanthocyanins', 'target']].groupby('target').mean().T.plot(kind='bar')
plt.show()
