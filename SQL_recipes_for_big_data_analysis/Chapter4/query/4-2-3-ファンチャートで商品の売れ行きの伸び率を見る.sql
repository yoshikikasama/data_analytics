-- ファンチャートとはある基準となる時点を100%として、以降の数値の変動を見るグラフ。
WITH
daily_category_amount AS (
    SELECT
        dt
        ,category
        -- - ■ PostgreseL, Hive, Redshift, SparksQLの場合は下記
        -- BigQueryの場合、substringをsubstrに修正
        ,SUBSTRING(dt,1,4) AS year
        ,SUBSTRING(dt,6,2) AS month
        ,SUBSTRING(dt,9,2) AS date 
        ,SUM(price) AS amount
    FROM purchase_detail_log
    GROUP BY dt,category
)

,monthly_category_amount AS (
    SELECT
        CONCAT(year,'-',month) AS year_month
        -- Redshiftの場合はconcat関数を組み合わせるか、｜演算子を用いる
        -- concat (concat (year, '-'), month) AS year_month
        -- year ||'-'|| month AS year_month
        ,category
        ,SUM(amount) AS amount
    FROM daily_category_amount
    GROUP BY year,month,category
)

SELECT
    year_month
    ,category
    ,amount
    ,FIRST_VALUE(amount) OVER (PARTITION BY category ORDER BY year_month,category ROWS UNBOUNDED PRECEDING) AS base_amount
    ,100.0 * amount / FIRST_VALUE(amount) OVER (PARTITION BY category ORDER BY year_month, category ROWS UNBOUNDED PRECEDING) AS rate
FROM
    monthly_category_amount
ORDER BY
    year_month,category;
