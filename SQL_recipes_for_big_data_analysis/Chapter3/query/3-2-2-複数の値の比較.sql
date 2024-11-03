-- コード3.2.2.2：年間の最大／最小の四半期売上を見つけるクエリ
SELECT
    year
    -- 01～04の最大売上を取得する
    , greatest (q1, q2, q3, 94) AS greatest_sales
    --01～04の最小売上を取得する
    , least (q1, q2, q3, 94) AS least_sales
FROM quarterly_sales
Order by year;


-- コード3.2.2.3：単純な加算による平均四半期売上を求めるクエリ
SELECT
    year
    , (q1 + q2 + q3 + q4) /4 as average
FROM
    quarterly_sales
ORDER BY year;


-- コード3.2.2.4:COALESCEを用いてNULLを0に置換した場合の平均値を求めるクエリ
SELECT
    year
    , (COALESCE (q1, 0) + COALESCE (q2, 0) + COALESCE (q3, 0) + COALESCE (q4, 0)) / 4 AS average
FROM
    quarterly_sales
ORDER BY
    year
;


-- コード3.2.2.5:NULLでないカラムのみを使用して平均値を求めるクエリ
-- SIGN関数: 引数が正の値であれば1, 0であれば0, 負の値であれば-1を返す
SELECT
    year
    , (COALESCE (q1, 0) + COALESCE (q2, 0) + COALESCE (q3, 0) + COALESCE(q4, 0)) 
    / (SIGN(COALESCE (q1, 0)) + SIGN(COALESCE (q2, 0))
    + SIGN(COALESCE (q3, 0)) + SIGN( COALESCE (q4, 0)))
    AS average
FROM
    quarterly_sales
ORDER BY
    year
