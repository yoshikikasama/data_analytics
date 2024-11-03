-- コード31.85:URLのバスをスラッシュで分割して簡層を抽出するケエリ
SELECT
    stamp
    , url
-- バスをスラッシュで配列に分解し、階層ごとに抽出するバスが必ずスラッシュから始まるので、2番目の要素が最初の階層となる
-- * PostgreseLの場合、Split_partでn番目の要素を抽出できる
    , split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) AS pathl
    , split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) AS path2
    -- ■ Redshiftの場合も、split_partでh番目の要素を抽出できる
    --, split_part(regexp_replace(regexp_substr (url, '//[^/]+[^?#]+*), #/[^/]+*, ''), '/', 2) AS path1
    -- , split_ part(regexp_replace(regexp_substr(url, '//[^/]+[^?#+*), '//[^/]+', ''), '', 3) AS path2
    -- ■ Bigeueryの場合、Split関数で配列に分解するが、配列のインデックス指定が特殊になる
    --, split(regexp_extract(url, '//[^/]+([^?#]+)'), */')[SAFE_ORDINAL(2)] AS path1
    --, split(regexp_extract(url, '//[^/]+([^?#]+)'), */')[SAFE_ORDINAL(3)] AS path2
    -- ■ Hive,SparksQLの場合も、split関数で配列に分解する
    -- ただし、配列のインデックスが0から始まる
    -- , split(parse _urI(url, 'PATH'), '/') [1] AS path1
    --, split(parse_url (url, 'PATH'), '/') [2] AS path2
from access_log;
