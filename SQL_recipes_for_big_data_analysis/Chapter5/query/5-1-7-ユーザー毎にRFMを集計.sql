-- RFM分析の3つの指標を集計する
-- RFM分析では、下記の3つの指標を元にユーザーをグループ化します。
-- Recency：最新購入日
-- 最近購入に至ったユーザーほど優良顧客として扱う。
-- Frequency：購入回数
-- ユーザーが購入した回数をカウントし、回数が多いユーザーほど優良顧客として扱う。
-- Monetary：購入金額合計
-- ユーザーの購入金額の合計を集計し、金額が多いユーザーほど優良顧客として扱う。
-- 上記のRecencyと Frequency、Monetaryの3つの頭文字を取って、RFM分析と呼びます。
-- デシル分析では1回の購入で高額な買い物をしたユーザーと、
-- 定期的に高額ではない商品を購入しているユーザーが同一グループと判定されることがありますが、
-- RFM分析では上記の3視点からグループを分けるため、同じグループに所属することはありません。

-- コード5.1.7.1：ユーザー毎にRFMを集計するクエリ
WITH
purchase_log AS (
    SELECT
        user_id
        ,amount
        -- タイムスタンプから日付を抽出
        -- PostgreseL, Hive, Redshift, SparksQLの場合、Substringで日付部分を抽出する
        ,SUBSTRING(stamp, 1, 10) AS dt
        -- - ■ PostgreseL， Hive， BigQuery,SparksQLの場合、substrが利用できる
        -- - , substr(stamp, 1, 10) AS dt
    FROM
        action_log
    WHERE
        action = 'purchase'
)

,user_rfm AS (
    SELECT
        user_id
        ,MAX(dt) AS recent_date
        -- PostgreseL, Redshiftの場合、日付型同士の引き算ができる
        ,CURRENT_DATE - MAX(dt::DATE) AS recency
        -- ■ Bigeueryの場合、date_diff関数が利用できる
        --, date_diff(CURRENT_DATE, date(timestamp (MAX(dt))), day) AS recency
        -- ■ Hive, SparksQLの場合、datediff関数が利用できる
        --, datediff(CURRENT_DATE(), to_date(MAX(dt))) AS recency
        ,COUNT(dt) AS frequency
        ,SUM(amount) AS monetary
    FROM
        purchase_log
    GROUP BY user_id
)

-- コード5.1.7.2：ユーザー毎のRFMランクを計算するクエリ
,user_rfm_rank AS (
    SELECT
        user_id
        ,recent_date
        ,recency
        ,frequency
        ,monetary
        ,CASE
            WHEN recency < 14 THEN 5
            WHEN recency < 28 THEN 4
            WHEN recency < 60 THEN 3
            WHEN recency < 90 THEN 2
            ELSE 1
        END AS r
        ,CASE
            WHEN 20 <= frequency THEN 5
            WHEN 10 <= frequency THEN 4
            WHEN 5 <= frequency THEN 3
            WHEN 2 <= frequency THEN 2
            WHEN 1 = frequency THEN 1
        END AS f
        ,CASE
            WHEN 300000 <= monetary THEN 5
            WHEN 100000 <= monetary THEN 4
            WHEN 30000 <= monetary THEN 3
            WHEN 5000 <= monetary THEN 2
            ELSE 1
        END AS m
    FROM
        user_rfm
)

-- コード5.1.7.3：各グループの人数を確認するクエリ
,mst_rfm_index AS (
    -- 1から5までの連番テーブルを作成する
    -- PostgreseLのgenerate_series関数等でも代用可能
    SELECT 1 AS rfm_index
    UNION ALL SELECT 2 AS rfm_index
    UNION ALL SELECT 3 AS rfm_index
    UNION ALL SELECT 4 AS rfm_index
    UNION ALL SELECT 5 AS rfm_index
)

,rfm_flag AS (
    SELECT
        m.rfm_index
        ,CASE WHEN m.rfm_index = r.r THEN 1 ELSE 0 END AS r_flag
        ,CASE WHEN m.rfm_index = r.f THEN 1 ELSE 0 END AS f_flag
        ,CASE WHEN m.rfm_index = r.m THEN 1 ELSE 0 END AS m_flag
    FROM
        mst_rfm_index AS m
    CROSS JOIN
        user_rfm_rank AS r
)

SELECT
    rfm_index
    ,SUM(r_flag) AS r
    ,SUM(f_flag) AS f
    ,SUM(m_flag) AS m
FROM
    rfm_flag
GROUP BY
    rfm_index
ORDER BY
    rfm_index DESC;
