-- コード3.3.2.1：ウィンドウ関数のORDER BY句を用いて、テーブル内の順序を扱うクエリ
SELECT
    product_id
    ,score
    --スコア順に一意なランキングを付与する
    -- ROW_NUMBER() は、行ごとに一意の連番を振る関数です。
    -- ORDER BY score DESC を指定することで、score が高い順に番号を振ります。スコアが同じでも必ず異なる番号が付与されます。
    ,ROW_NUMBER() OVER (ORDER BY score DESC) AS row
    --同順位を許容するランキングを付与する
    -- RANK() は、順位を付ける関数です。score が同じ場合、同順位が許容されます。
    -- 同順位の次の順位はスキップされるため、同順位が2つあれば次の順位は2つ飛びます（たとえば、1位が2つあれば次は3位）。
    ,RANK() OVER (ORDER BY score DESC) AS rank
    --同順位を許容し、同順位の次の順位を飛ばさないランキングを付与する
    -- DENSE_RANK() は RANK() と似ていますが、同順位の次の順位を飛ばしません。
    -- 例えば、1位が2つあった場合、次の順位は2位となります。
    ,DENSE_RANK() OVER (ORDER BY score DESC) AS dense_rank
    -- 現在の行より前の行の値を取得する
    -- LAG(product_id) は、現在の行の「直前の行」にある product_id の値を取得します。
    -- ORDER BY score DESC を指定しているため、スコアの高い順に並んだ場合の直前の行が取得されます。
    ,LAG(product_id) OVER (ORDER BY score DESC) AS lag1
    ,LAG(product_id,2) OVER (ORDER BY score DESC) AS lag2
    -- 現在の行より後の行の値を取得する
    -- LEAD(product_id) は、現在の行の「直後の行」にある product_id の値を取得します。
    ,LEAD(product_id) OVER (ORDER BY score DESC) AS lead1
    -- LEAD(product_id, 2) は、現在の行から「2つ後の行」にある product_id の値を取得します。
    ,LEAD(product_id,2) OVER (ORDER BY score DESC) AS lead2
FROM popular_products
ORDER BY row;


-- ORDER BY 句と集約関数を組み合わせた計算を行うクエリ
SELECT
    product_id
    ,score
    -- スコア順に一意なランキングを付与する
    ,ROW_NUMBER() OVER (ORDER BY score DESC) AS row
    -- ランキング上位からの累計スコア合計を計算する
    -- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW は、最上位の行（スコアが最も高い行）から現在の行までの累計を計算します。
    ,SUM(score) OVER (ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_score
    --  いまの行と前後1行ずつの、合計3行の平均スコアを計算する
    -- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING で、現在の行の前後1行を含む3行の範囲を指定しています。
    ,AVG(score) OVER (ORDER BY score DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS local_avg
    -- ランキング最上位の商品IDを取得する
    -- FIRST_VALUE(product_id) は、指定された範囲で最初の行の product_id を取得します。
    -- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING で、ウィンドウ全体を指定しています。
    -- この結果、最初の行（スコアが最も高い行）の product_id が全ての行に表示されます。
    ,FIRST_VALUE(product_id) OVER (ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_value
    -- ランキング最下位の商品IDを取得する
    -- LAST_VALUE(product_id) は、指定された範囲で最後の行の product_id を取得します。
    -- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING で、ウィンドウ全体を指定しているため、最下位の行（スコアが最も低い行）の product_id が全ての行に表示されます。
    ,LAST_VALUE(product_id) OVER (ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_value
FROM popular_products
ORDER BY row;


-- コード3.3.2.3：ウィンドウのフレーム指定ごとに商品IDを集約するクエリ
SELECT
    product_id
    -- スコア順に一意なランキングを付与する
    ,ROW_NUMBER() OVER (ORDER BY score DESC) AS row
    -- ランキングの最初から最後までの範囲を対象に商品IDを集約
    ,ARRAY_AGG(product_id) OVER (ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS whole_agg
    -- ランキングの最初から現在の行までの範囲を対象に商品IDを集約
    ,ARRAY_AGG(product_id) OVER (ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_agg
    -- ランキングの一つ前から一つ後までの範囲を対象に商品IDを集約
    ,ARRAY_AGG(product_id) OVER (ORDER BY score DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS local_agg
FROM popular_products
WHERE category = 'action'
ORDER BY row
;

-- コード3.3.2.4：ウィンドウ関数を用いてカテゴリごとの順位を計算するクエリ
SELECT
    category
    ,product_id
    ,score
    -- categoryごとに、スコア順に一意なランキングを付与する
    ,ROW_NUMBER() OVER (PARTITION BY category ORDER BY score DESC) AS row
    -- categoryごとに、同順位を許容するランキングを付与する
    ,RANK() OVER (PARTITION BY category ORDER BY score DESC) AS rank
    -- categoryごとに、同順位を許容し、同順位の次の順位を飛ばさないランキングを付与する
    ,DENSE_RANK() OVER (PARTITION BY category ORDER BY score DESC) AS dense_rank
FROM popular_products
ORDER BY category, row
;

-- コード3.3.2.5：カテゴリごとのランキング上位2件までの商品を抽出するクエリ
-- サブクエリなしで WHERE 句を直接使うことはできません。
-- その理由は、ウィンドウ関数は WHERE 句が適用される前に計算されないからです。
SELECT
    *
FROM
    -- サブクエリ内でランキングを計算
    (
        SELECT
            category
            ,product_id
            ,score
            -- カテゴリごとに、スコア順に一意なランキングを付与する
            ,ROW_NUMBER() OVER (PARTITION BY category ORDER BY score DESC) AS rank
        FROM popular_products
    ) AS popular_products_with_rank
-- 外側のクエリでランクを絞り込む
WHERE rank <= 2
ORDER BY category,rank;


-- コード3.3.2.6：カテゴリごとのランキング最上位の商品を抽出するクエリ
-- DISTINCT句を付与して重複を排除する
SELECT DISTINCT
    category
    -- カテゴリごとにランキング最上位の商品IDを取得する
    ,FIRST_VALUE(product_id) OVER (PARTITION BY category ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS product_id
FROM popular_products;
