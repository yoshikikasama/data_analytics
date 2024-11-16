-- コード4.1.3.1：日別の売上と当月累計売上を集計するクエリ
SELECT
    dt
    --「年一月」を抽出する
    --■ PostgreseL, Hive, Redshift, SparksQLの場合、substringで「年一月」部分を抽出する
    ,SUBSTRING(dt,1,7) AS year_month
    -- - ■ PostgreseL， Hive， Bigluery,SparkseLの場合、Substrが利用できる
    -- ,SUBSTR(dt,1,7) AS year_month
    ,SUM(purchase_amount) AS total_amount
    -- 1. 内側の SUM(purchase_amount)
    -- 最初に、日付 (dt) ごとの売上 (purchase_amount) を集計しています。この集計は GROUP BY dt によって行われています。
    -- 2. 外側の SUM(...) OVER
    -- 次に、この日付ごとの集計結果に対して 累積合計 (Cumulative Sum) を計算しています。
    -- 月の最初の日から現在の日までの累積売上を計算。
    ,SUM(SUM(purchase_amount))
    -- - • PostgreSQL, Hive, Redshift, SparkSQLの場合は下記
        OVER (PARTITION BY SUBSTRING(dt,1,7) ORDER BY dt ROWS UNBOUNDED PRECEDING)
    AS agg_amount
    -- ■ BigQueryの場合、substringをsubstrに修正
    -- OVER (PARTITION BY substr(dt, 1, 7) ORDER BY dt ROWS UNBOUNDED PRECEDING) AS agg_amount
FROM
    purchase_log
GROUP BY dt
ORDER BY dt;


-- コード4.1.3.2：日別の売上を一時テーブル化するクエリ
WITH
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

SELECT
    *
FROM
    daily_purchase
ORDER BY dt;


-- コード4.1.3.3：daily_purchaseテーブルに対して当月累計売上を集計するクエリ
WITH
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

SELECT
    dt
    ,CONCAT(year,'-',month) AS year_month
    -- Redshiftの場合はconcat関数を組み合わせるか、演算子を用いる
    -- , concat(concat(year, '-'), month) AS year_month
    --, year ||'-' || month AS year _month , purchase_amount
    ,SUM(purchase_amount) OVER (PARTITION BY year, month ORDER BY dt ROWS UNBOUNDED PRECEDING) AS agg_amount
FROM daily_purchase
ORDER BY dt
