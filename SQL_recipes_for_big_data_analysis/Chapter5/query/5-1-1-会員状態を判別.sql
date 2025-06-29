-- コード5.1.1.4：会員状態を判別するクエリ
WITH
action_log_with_status AS (
    SELECT
        session
        ,user_id
        ,action
        -- ログをタイムスタンプ順に並べ、一度でもログインしたことのあるセッションの場合、
        -- それ以降のログのステータスをmemberとする
        ,CASE
            WHEN
                -- COALESCE: 最初に NULL ではない値を返します。全ての引数が NULL の場合は、NULL を返します。
                COALESCE(MAX(user_id) OVER (PARTITION BY session ORDER BY stamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),'') <> ''
                THEN 'member'
            ELSE 'none'
        END AS member_status
        ,stamp
    FROM
        action_log
)

SELECT *
FROM
    action_log_with_status
