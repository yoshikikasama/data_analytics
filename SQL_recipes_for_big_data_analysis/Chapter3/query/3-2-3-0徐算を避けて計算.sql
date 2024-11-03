-- コード3.2.3.2:0除算を避けてCTRを計算するクエリ
SELECT
    dt
    ,ad_id
    -- CASE式で分母が日の場合を分はして、8除算を避ける方法
    ,CASE
        WHEN impressions > 0 THEN 100.0 * clicks / impressions
    END AS ctr_as_percent_by_case
    -- 分母がの場合はNULLに変換し、8除算を避ける方法
    -- ■ PostgreseL, Redshift, BigQuery, SparkseLの場合、
    -- NULLIF関数が利用できる NULLIFはNULLを含む値がある場合resultもNULLとなる。

    ,100.0 * clicks / NULLIF(impressions,0) AS ctr
    -- ■ Hiveの場合、NULLIFの代わりにCASE式を用いる
    -- ,100.0 * clicks
    -- / CASE WHEN impressions = 0 THEN NULL ELSE impressions END
    -- AS ctr_as_percent_by_null
FROM
    advertising_stats
ORDER BY dt,ad_id
