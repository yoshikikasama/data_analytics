-- コード4.1.2.1：日別の売上と7日移動平均を集計するクエリ
SELECT
    dt
    ,SUM(purchase_amount) AS total_amount
    --直近の最大7日間の平均を計算する
    -- ROWS は行ベースで計算範囲を指定するキーワードです。
    -- SUM(purchase_amount) を日付ごとに集計した後、その結果の平均を計算します。
    ,AVG(SUM(purchase_amount)) OVER (ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS seven_day_avg
    --厳密に直近の7日間の平均を計算する
    ,CASE
        WHEN
            7 = COUNT(*) OVER (ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
            THEN
                AVG(SUM(purchase_amount))
                    OVER (ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
    END AS seven_day_avg_strict
FROM purchase_log
GROUP BY dt
ORDER BY dt
