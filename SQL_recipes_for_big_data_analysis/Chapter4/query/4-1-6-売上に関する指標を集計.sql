-- コード4.1.6.1：売上に関する指標を集計するクエリ
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

,monthly_purchase AS (
    SELECT
        year
        ,month
        ,SUM(orders) AS orders
        ,AVG(purchase_amount) AS avg_amount,
        SUM(purchase_amount) AS monthly
    FROM daily_purchase
    GROUP BY year,month
)

SELECT
    CONCAT(year,'-',month) AS year_month
    -- - ■ Redshiftの場合はconcat関数を組み合わせるか、｜演算子を用いる
    -- concat (concat (year, '-'), month) AS year_month
    -- year ||'-' || month AS year_month 
    ,orders
    ,avg_amount
    ,monthly
    ,SUM(monthly) OVER (PARTITION BY year ORDER BY month ROWS UNBOUNDED PRECEDING) AS agg_amount
    -- 12ヶ月前の売上を求める
    -- 「1年前（12ヶ月前）の売上額」を取得する。
    ,LAG(monthly,12) OVER (ORDER BY year,month)
    -- ■ SparksQLの場合は下記を用いる
    -- OVER ORDER BY year, month ROWS BETWEEN 12 PRECEDING AND 12 PRECEDING) 
    AS last_year
    --12ヶ月前の売上に対する割合を求める
    ,100.0
    * monthly
    / LAG(monthly,12) OVER (ORDER BY year,month)
    -- ■SparksqLの場合は下記を用いる
    -- OVER(ORDER BY year, month ROWS BETWEEN 12 PRECEDING AND 12 PRECEDING) 
    AS rate
FROM
    monthly_purchase
ORDER BY year_month
