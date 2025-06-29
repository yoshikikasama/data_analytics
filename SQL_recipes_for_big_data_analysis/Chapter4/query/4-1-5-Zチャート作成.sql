-- コード4.1.5.1：2015年の売上に対するZチャートを作成するクエリ
WITH
-- 日ごとの売上データがまとめられる。
daily_purchase AS (
    SELECT
        dt
        --「年」「月」「日」をそれぞれ抽出する
        -- PostgreSQL, Hive, Redshift, SparkSQLの場合は下記
        -- - ■ BigQueryの場合、SubstringをSubstrに修正
        ,SUBSTRING(dt,1,4) AS year
        ,SUBSTRING(dt,6,2) AS month
        ,SUBSTRING(dt,9,2) AS date
        ,SUM(purchase_amount) AS purchase_amount
        ,COUNT(order_id) AS orders
    FROM purchase_log
    GROUP BY dt
)

,monthly_purchase AS (
    --月別の売上 集計
    SELECT
        year
        ,month
        ,SUM(purchase_amount) AS amount
    FROM daily_purchase
    GROUP BY year,month
)

,calc_index AS (
    SELECT
        year
        ,month
        ,amount
        -- 2015年の累計売上を計算
        -- 2015年のデータの場合のみ、その月の売上金額を計算。
        -- その月までの累積売上を計算（例: 1月の売上 + 2月の売上 + ...）。
        -- ROWS UNBOUNDED PRECEDING:
        -- 現在の行から、最初の行までのすべての行を範囲に含めます。
        -- OVER句でウィンドウの範囲を定義します。その中で、以下の要素を設定できます
        --  ROWSまたはRANGE: 行の範囲**
        -- ウィンドウ内で対象とする範囲を指定します。
        -- 現在の行を含むウィンドウ内で、指定されたカラム（ここでは amount）を合計します。
        -- ウィンドウ関数を使うと、GROUP BYとは異なり、元のデータ構造を壊さずに集計が可能です。
        -- OVER句を使うことで、ウィンドウ（集計の対象となるデータ範囲）を指定し、その範囲内で**SUM**（や他の集計関数）が計算されます。
        ,SUM(CASE WHEN year = '2015' THEN amount END) OVER (ORDER BY year,month ROWS UNBOUNDED PRECEDING) AS agg_amount
        --当月から11ヶ月前までの合計売上（移動年計）を計算
        ,SUM(amount) OVER (ORDER BY year,month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS year_avg_amount
    FROM
        monthly_purchase
    ORDER BY
        year,month
)

--最後に、2015年のデータのみに絞り込む
SELECT
    CONCAT(year,'-',month) AS year_month
    -- ■ Redshiftの場合はconcat関数を組み合わせるか、｜演算子を用いる
    -- concat (concat (year, '-'), month) AS year_month
    -- year || '-' || month AS year_month
    ,amount
    ,agg_amount
    ,year_avg_amount
FROM
    calc_index
WHERE
    year = '2015'
ORDER BY year_month
