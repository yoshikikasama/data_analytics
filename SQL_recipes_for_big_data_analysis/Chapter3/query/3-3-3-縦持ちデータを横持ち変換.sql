-- コード3.3.3.1：行で保存された指標の値を列に変換するクエリ
SELECT
    dt
    ,MAX(CASE WHEN indicator = 'impressions' THEN val END) AS impressions
    ,MAX(CASE WHEN indicator = 'sessions' THEN val END) AS sessions
    ,MAX(CASE WHEN indicator = 'users' THEN val END) AS users
FROM daily_kpi
GROUP BY dt
ORDER BY dt;

-- コード3.3.3.2：行を集約してカンマ区切りの文字列に変換するクエリ
SELECT
    purchase_id
    -- 商品IDを配列に集約し、カンマ区切りの文字列に変換
    -- ■ PostgreseL, BigQueryの場合はstring_aggを用いる
    ,STRING_AGG(product_id,',') AS product_ids
    -- ■ Redshiftの場合は1istaggを用いる
    -- , listagg(product_id, ',') AS product_ids
    -- Hive, SparkseLの場合はcollect_1istとconcat_WSを用いる
    --, concat_ws(',', collect_list(product_id)) AS product_ids
    ,SUM(price) AS amount
FROM purchase_detail_log
GROUP BY purchase_id
ORDER BY purchase_id
