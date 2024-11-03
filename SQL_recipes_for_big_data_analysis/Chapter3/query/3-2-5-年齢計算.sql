-- コード3.2.5.3：age関数を用いて年齢を計算するクエリ
SELECT
    user_id
    -- ■ PostgresQLの場合、age関数とEXTRACT関数を用いて年単位の年齢を計算できる
    ,CURRENT_DATE AS today
    ,register_stamp::DATE AS register_date
    ,birth_date::DATE AS birth_date
    ,EXTRACT(YEAR FROM AGE(birth_date::DATE)) AS current_age
    ,EXTRACT(MONTH FROM AGE(birth_date::DATE)) AS current_age_month
    ,EXTRACT(DAY FROM AGE(birth_date::DATE)) AS current_age_day
    ,AGE(birth_date::DATE) AS age
    ,EXTRACT(YEAR FROM AGE(register_stamp::DATE,birth_date::DATE)) AS register_age
FROM
    mst_users_with_birthday;

-- コード3.2.5.5：日付を整数で表現して年齢を計算するクエリ
-- 誕生日が2000年2月29日の人の、2016年2月28日時点での年齢を計算
SELECT FLOOR((20160228 - 20000229) / 10000) AS age;



-- コード3.2.5.6：文字列型の誕生日から、登録時点と現在時点での年齢を計算するクエリ
SELECT
    user_id
    ,substring(register_stamp, 1, 10) AS register_date
    ,birth_date
    --登録時点での年齢を計算
    -- floorは指定された数値の小数点以下を切り捨てる
    ,floor (
        ( CAST (replace(substring (register_stamp, 1, 10), '-', '') AS integer)
            - CAST (replace(birth_date, '-', '') AS integer)
        ) / 10000
    ) AS register_age
    --現在時点での年齢を計算
    , floor (
        ( CAST (replace(CAST (CURRENT_DATE AS text), '-', '') AS integer)
            - CAST (replace(birth_date, '-', '') AS integer)
        ) / 10000
    ) AS current_age
    -- ■ Bigeueryの場合、textをstring,integerをint64に置き換える
    -- ( CAST (replace(CAST(CURRENT_DATE AS string), '-'
    -- , '') AS int64)
    -- - CAST (replace(birth_date, '-'
    -- , '') AS int64)
    -- ) / 10000
    -- • Hive, SparksQLOtA,replaceregexp_replace, text&string,
    -- integerをintに置き換える
    -- SparkSQLの場合はさらにCURRENT_DATEをCURRENT_DATE（）に置き換える
    -- ( CAST(regexp_replace(CAST(CURRENT_DATE() AS string),
    -- CAST (regexp_replace(birth_date, '-', "') AS int)
    -- ) / 10000
FROM mst_users_with_birthday;
