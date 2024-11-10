-- コード3.4.2.1：複数のテーブルを結合して横に並べるクエリ
SELECT
    m.category_id
    ,m.name
    ,s.sales
    ,r.product_id AS sale_product
FROM
    mst_categories AS m
JOIN
    -- カテゴリー別の売上額を結合する
    category_sales AS s
    ON m.category_id = s.category_id
JOIN
    -- カテゴリー別の商品を結合する
    product_sale_ranking AS r
    ON m.category_id = r.category_id;

-- コード3.4.2.2：マスタテーブルの行数を変えずに複数のテーブルを横に並べるクエリ
SELECT
    m.category_id
    ,m.name
    ,s.sales
    ,r.product_id AS top_sale_product
FROM
    mst_categories AS m
-- 右外部結合を用いて結合できなかったレコードを残す
LEFT JOIN
    -- カテゴリー別の売上額を結合する
    category_sales AS s
    ON m.category_id = s.category_id
-- 右外部結合を用いて結合できなかったレコードを残す
LEFT JOIN
    -- カテゴリー別のトップ売上商品を1件取得し結合する
    product_sale_ranking AS r
    ON m.category_id = r.category_id
        AND r.rank = 1;


-- コード3.4.2.3：相関サブクエリで複数のテーブルを横に並べるクエリ
SELECT
    m.category_id
    ,m.name
    -- 相関サブクエリでカテゴリー別の売上額を取得
    ,(
        SELECT s.sales
        FROM category_sales AS s
        WHERE m.category_id = s.category_id
    ) AS sales
    -- 相関サブクエリでカテゴリー別のトップ売上商品を1件取得（ランクによる込が不要）
    ,(
        SELECT r.product_id
        FROM product_sale_ranking AS r
        WHERE m.category_id = r.category_id
        ORDER BY sales DESC
        LIMIT 1
    ) AS top_sale_product
FROM
    mst_categories AS m
