WITH
action_log_with_dt AS (
    SELECT
        *
        -- ・・タイムスタンプから日付を抽出
        -- - ■ PostgreseL, Hive, Redshift, SparksqLの場合、Substringで日付部分を抽出する
        ,SUBSTRING(stamp,1,10) AS dt
        -- - ■ PostgreseL, Hive, BigQuery,SparksqLの場合、Substrが利用できる
        -- - , substr (stamp, 1, 10) AS dt
    FROM action_log
)

,action_day_count_per_user AS (
    SELECT
        user_id
        ,COUNT(DISTINCT dt) AS action_day_count
    FROM
        action_log_with_dt
    WHERE
        --2016年11月1日～11月7日の1週間分を対象とする
        dt BETWEEN '2016-11-01' AND '2016-11-07'
    GROUP BY user_id
)

-- コード5.1.4.2：構成比と構成比累計を計算するクエリ
SELECT
    action_day_count
    ,COUNT(DISTINCT user_id) AS user_count
    --構成比
    ,100.0 * COUNT(DISTINCT user_id) / SUM(COUNT(DISTINCT user_id)) OVER () AS composition_ratio
    -- 構成比累計
    ,100.0 * SUM(COUNT(DISTINCT user_id)) OVER (ORDER BY action_day_count ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(COUNT(DISTINCT user_id)) OVER () AS cumulative_ratio
FROM
    action_day_count_per_user
GROUP BY
    action_day_count
ORDER BY
    action_day_count
