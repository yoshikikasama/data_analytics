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
    month
    ,SUM(CASE year WHEN '2014' THEN purchase_amount END) AS amount_2014
    ,SUM(CASE year WHEN '2015' THEN purchase_amount END) AS amount_2015
    -- 今年度 / 前年度 * 100
    ,100.0
    * SUM(CASE year WHEN '2015' THEN purchase_amount END)
    / SUM(CASE year WHEN '2014' THEN purchase_amount END)
    AS rate
FROM
    daily_purchase
GROUP BY month
ORDER BY month
