-- 3-2-2のデータ
-- コード3.3.4.1：連番を持つビボットテーブルを用いて列を行に変換するクエリ
SELECT
    q.year
    -- 01から04までのラベル名を表示
    ,CASE
        WHEN p.idx = 1 THEN 'q1'
        WHEN p.idx = 2 THEN 'q2'
        WHEN p.idx = 3 THEN 'q3'
        WHEN p.idx = 4 THEN 'q4'
    END AS quarter
    -- 01から04までの売上を表示
    ,CASE
        WHEN p.idx = 1 THEN q.q1
        WHEN p.idx = 2 THEN q.q2
        WHEN p.idx = 3 THEN q.q3
        WHEN p.idx = 4 THEN q.q4
    END AS sales
FROM
    quarterly_sales AS q
CROSS JOIN
-- 行に展開したい列数分の連番テーブルを作成する
    (
        SELECT 1 AS idx
    UNION ALL SELECT 2 AS idx
    UNION ALL SELECT 3 AS idx
    UNION ALL SELECT 4 AS idx
    ) AS p;


-- コード3.3.4.2：テーブル関数を用いて配列を行に展開するクエリ
-- PostgreSQLの場合、unnest関数を用いる
SELECT UNNEST(ARRAY['A001','A002','A003']) AS product_id;
--■ BigQueryの場合もunnest関数を用いるが、テーブル関数はFROM旬内でしか使えない
-- SELECT * FROM unnest (ARRAY['A001', 'A002', 'A003']) As product _id;
-- ■ Hive, SparksQLの場合、explode関数を用いる
-- SELECT explode (ARRAY('A001', 'A002', 4003')) AS product_id;


-- コード3.3.4.3：テーブル関数を用いてカンマ区切りのデータを行に展開するクエリ
SELECT
    purchase_id
    ,product_id
FROM
    purchase_log AS P
-- string_to_array関数で文字列を配列に変換し、unnest関数でテーブルに変換する
CROSS JOIN unnest(string_to_array(product_ids,',')) AS product_id
-- BigQueryの場合は、文字列の分解にsp1it関数を用いる
-- CROSS JOIN unnest (split(product_ids, ',')) AS product_ id
-- ■ HiveやSparksQKの場合は、LATERAL VIEW explodeを用いる
-- LATERAL VIEW explode(split(product_ids, ',')) e AS product_id;
;

-- コード3.3.4.4：PostgresQLでカンマ区切りのデータを行に展開するクエリ
SELECT
    purchase_id
    -- カンマ区切りの文字列を一度に行に展開する
    ,regexp_split_to_table(product_ids, ',') AS product_id
FROM purchase_log;


-- コード3.3.4.6：split_part関数の使用例
SELECT
    split_part('A001, A002, A003', ',',1) AS part_1
    , split_part ('A001, A002, A003', ',',2) AS part_2
    , split_part ('A001, A002, A003', ',',3) AS part_3
;


-- コード3.3.4.7：文字数の差を用いて商品数をカウントするクエリ
SELECT
    purchase_id
    ,product_ids
    この 1 は、商品数の計算において、カンマの数に 1 を足している部分です。

    -- 具体的には、カンマは「区切り文字」であり、商品がいくつあるかを表すのに使われています。
    -- カンマが1つある場合、商品が2つあると考えられるからです。
    -- したがって、「カンマの数 + 1」が商品数となります。
    -- 元の文字列の長さから、カンマを取り除いた後の文字列の長さを引きます。
    -- この結果、カンマの数が得られます。このカンマの数に 1 を足すことで、商品IDの個数を計算しています。
    --商品IDの文字列からカンマを取り除き、文字数の差を計算して商品数を取得する
    ,1 + char_length(product_ids) - char_length(replace(product_ids, ',', '')) AS product_num
FROM
    purchase_log;

-- コード3.3.4.8：ピボットテーブルを用いて文字列を行に展開するクエリ
SELECT
    l.purchase_id
    ,l.product_ids
    -- 商品の数だけ連番を付与する
    ,p.idx
    -- 文字列をカンマ区切りで分割し、idx番目の要素を取り出す
    ,split_part(l.product_ids,',',p.idx) AS product_id
FROM
    purchase_log AS l
    JOIN
    (
        SELECT 1 AS idx
        UNION ALL SELECT 2 AS idx
        UNION ALL SELECT 3 AS idx
    ) AS p
    --ピボットテーブルのidが、商品の数以下の場合のみ結合する
    ON p.idx <=
        (1 + char_length(l.product_ids)
            - char_length(replace(l.product_ids,',','')))


