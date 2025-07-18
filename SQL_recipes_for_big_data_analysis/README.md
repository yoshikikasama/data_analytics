# ビッグデータ分析・活用のための SQL レシピ

## 概要

このアーカイブに含まれるファイルは、『ビッグデータ分析・活用のための SQL レシピ』（マイナビ出版）に掲載されている各種テーブル定義など、サンプルデータです。

「Chapter3」〜「Chapter8」までのフォルダに、各章内で使用するサンプルデータを項別に配置しています（Chapter1 と Chapter2、Chapter9 のサンプルデータはありません）。同一のテーブルを別の項で使用する場合でも、項ごとに動作確認ができるように重複してデータを保持しています。

なお、ここで提供するデータは本書で紹介するクエリを動作確認するためのダミーデータであるため、本書内での出力結果とは必ずしも一致しません。予めご了承ください。

## MEMO

- GROUP BY

  - SELECT 句に指定できるカラムは GROUP BY 句に指定したカラムか集約関数(SUM,COUNT,AVG..)のみ。
  - GROUP BY 句を使用したクエリでは、GROUP BY 句に指定したカラムをユニークキーとして、新たなテーブルが作られます。その過程で GROUP BY 句に指定していないカラムの値は失われるため。

- ウィンドウ関数の基本構成
  - テーブルの中でウィンドウと呼ばれるある種の範囲を定義し、その範囲内に含まれる値を特定のレコードから自由に利用できるように定義したもの。
- ウィンドウ関数の基本的な形は以下のようになります：

```sql
  関数名(列名) OVER (PARTITION BY 列名 ORDER BY 列名)
```

- OVER キーワードを使って、どの範囲で集約や計算を行うかを指定します。
- PARTITION BY: データを特定の範囲（パーティション）に分けて処理します。たとえば user_id でパーティションを分ければ、ユーザーごとに計算を行います。
- ORDER BY: パーティション内での並び順を指定します。これがあると、ランキング関数なども使えます。
- ウィンドウ関数の例
  - 以下、ウィンドウ関数を使って平均スコアをユーザーごとに計算する例です。

```sql
SELECT
    user_id,
    score,
    AVG(score) OVER (PARTITION BY user_id) AS user_avg_score
FROM
    review;
```

- このクエリは次のことをしています：

  - PARTITION BY user_id で、ユーザーごとにデータを分けています。
  - AVG(score) は、各ユーザーの平均スコアを計算します。
  - 結果として、user_id が同じ行すべてに同じ user_avg_score が表示されます。
  - なぜウィンドウ関数が便利か？
    - 通常、集約関数を使うと GROUP BY と一緒に使う必要があり、データが「グループ化」されてしまいます。そのため、詳細な行データを失うことがあります。ウィンドウ関数を使えば、各行に対して集約データ（たとえば平均値など）を「そのまま」表示できるので、元のデータと集約結果を同時に扱えます。

- ROWS BETWEEN ... AND ...
  - ウィンドウ関数の集計範囲を指定するために使います。ウィンドウ関数が適用される際に、「どの範囲のデータを含めて計算するか」を制御できます。
  - ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  - 意味: 最初の行から現在の行までのすべての行を範囲に含む。
  - 用途: 累積計算（例えば、現在の行までの累積合計や累積平均）に便利です。
- UNBOUNDED PRECEDING
  - 「無限に前の行」＝つまり、テーブルの最初の行から
- UNBOUNDED FOLLOWING
  - 「無限に後の行」＝つまり、テーブルの最後の行まで。
- n PRECEDING
  - n 行前
- n FOLLOWING
  - n 行後
-

### コード 3.3.4.8：ピボットテーブルを用いて文字列を行に展開するクエリ

わかりやすく言うと、このクエリは「`product_ids` に含まれる商品の数だけ行を作りたい」のですが、そのために「商品の数より多い行は作らないように制限している」ということです。

具体的に説明します。

---

### 例として、`product_ids` が `"123,456,789"` の場合を考えます

この `product_ids` には、3 つの商品 ID（123、456、789）が含まれています。この場合、クエリは以下のように 3 行を作りたいです：

| purchase_id | product_ids | idx | product_id |
| ----------- | ----------- | --- | ---------- |
| 1           | 123,456,789 | 1   | 123        |
| 1           | 123,456,789 | 2   | 456        |
| 1           | 123,456,789 | 3   | 789        |

このためには、「3 つの行だけ」作ればいいので、`idx`（インデックス）が 1 から 3 までの範囲であれば良いわけです。

### クエリの仕組み

クエリはまず、「1 から 3 の連番を持つテーブル」を作ります。これが次の部分です：

```sql
(
    SELECT 1 AS idx
    UNION ALL SELECT 2 AS idx
    UNION ALL SELECT 3 AS idx
) AS p
```

この部分で作られたテーブル `p` は、次のような行を持っています：

| idx |
| --- |
| 1   |
| 2   |
| 3   |

次に、これと `purchase_log` テーブルを結合することで、`idx` が 1、2、3 の行と `product_ids` を組み合わせて商品 ID を抽出します。

### 条件付き結合

しかし、`product_ids` の商品数がいつも 3 つとは限りません。たとえば、`product_ids` が `"987,654"` の場合、商品数は 2 つです。このときは `idx` が 1 と 2 だけの 2 行だけを作りたいので、`idx` が 3 の行は結合しないように制限をかけます。

そのために、以下の条件を使って「商品の数より多い行は作らないように」制限しています：

```sql
ON p.idx <= (1 + char_length(l.product_ids) - char_length(replace(l.product_ids, ',', '')))
```

この部分の計算 `(1 + char_length(l.product_ids) - char_length(replace(l.product_ids, ',', '')))` は、「`product_ids` に含まれる商品数」を表しています。カンマの数に 1 を足すことで、商品がいくつあるかを求めています。

### まとめると

- `product_ids` の商品数が 3 なら、`idx` は 1 から 3 までの行が結合される
- `product_ids` の商品数が 2 なら、`idx` は 1 と 2 だけが結合される

このようにして、`product_ids` に含まれる商品の数に応じて行数が決まるようになっています。

SQL では、データを行から列に変換する「ピボット操作」と、列から行に変換する「アンピボット操作」の両方が行われます。このクエリで行っているのは、「アンピボット」操作です。

### SQL 実行順序

1. FROM で処理対象テーブルを選択
2. WHERE による絞り込み
3. GROUP BY によるグループ化
4. HAVING による絞り込み
5. SELECT
6. ORDER BY によるソート
7. LIMIT による絞り込み

実行順序を理解することは、SQL のパフォーマンス向上や、複雑なクエリを作成する上で重要となる

```sql
SELECT -- 5
 receipt_id
 ,ROUND(AVG(price), 0) AS avg_price
FROM -- 1
 receipt_item
WHERE -- 2
 price > = 0
GROUP BY -- 3
 receipt_id
HAVING -- 4
 AVG(price) = 500
ORDER BY -- 6
LIMIT -- 7
```

- 月次売上: 売り上げの合計を月別に集計
- 売上累計: 該当月の売り上げに前月までの売上累計を合計した値
- 移動年計: 該当月の売上に過去 11 ヶ月の売上累計を合計する。

- Z チャートを読み解くポイント
  - 売上累計への着目: 月次売上が一定の場合、売上累計は直線になります。横軸で右に行くほどグラフの傾きが急になる曲線であれば、直近の売上は上昇傾向となり、緩やかになっていれば直近の売上は減少傾向となります。グラフの表示期間で、売上がどのように推移しているのかを読み解くことが可能です
  - 移動年計への着目: 前年から当年にかけて売上が一定の場合は、移動年計は直線になります。右肩上がりになっている場合、売上は上昇傾向となり、右肩下がりであれば減少傾向となります。グラフに表示されていない過去 1 年の長いスパンで、売上がどのように推移しているのかを読み解くことができます

-　 LAG 関数の構文

```sql
LAG(<列名>, <オフセット>, <デフォルト値>) OVER (<ウィンドウ定義>)
```

- <列名>: 取得したい値がある列を指定します。
- <オフセット>: 現在の行からどれだけ前の行の値を取得するかを指定します（デフォルトは 1）。
- <デフォルト値>: 前の行が存在しない場合に返す値（省略可能）。
- OVER 句: ウィンドウの定義を指定します（ORDER BY で並び順を指定するのが一般的）。

### RFP 分析

RFM ランクを定義する
RFM 分析では、3 つの指標をそれぞれ 5 つのグループに分けるのが一般的です。したがって、125（＝ 5x5x5）のグループでユーザーを捉えることができます。
上記コード例の出力結果でデータの分布を見ながら、各項目を定義付けします。本項では、次表に示す通りに、RFM ランクを定義します。

| ランク | R：最新購入日 | F：累計購入回数 | M：累計購入金額 |
| ------ | ------------- | --------------- | --------------- |
| 5      | 14 日以内     | 20 回以上       | 30 万円以上     |
| 4      | 28 日以内     | 10 回以上       | 10 万円以上     |
| 3      | 60 日以内     | 5 回以上        | 3 万円以上      |
| 2      | 90 日以内     | 2 回以上        | 5000 円以上     |
| 1      | 91 日以上     | 1 回のみ        | 5000 円未満     |
