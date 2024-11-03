-- コード3.1.2.1：リファラーのドメインを抽出するクエリ

SELECT
    stamp
    -- referrerのホスト名部分を抽出する
    -- ■ PostgresQLの場合、substring関数と正規表現を用いる
    , substring(referrer from 'https?://([^/]*)') AS referrer_host

    -- Redshiftの場合、正規表現にパーレンが使用できないため、regexp_substr関数とregexp_replace関数を組み合わせる
    -- , regexp_replace (regexp_substr(referrer, 'https?://[^/]*'), 'https?://', '') AS referrer_host
    -- Hive, SparksQLの場合、parse_ur1関数でホスト名を抽出できる
    --, parse_uri(referrer, 'HOST') AS referrer_host
    -- BigQueryの場合はhost関数が利用できる
    --, host (referrer) AS referrer_host
FROM access_log


-- コード3.1.2.2：URLのパスとGETパラメーターにある特定のキーの値を取り出すクエリ
SELECT
    stamp
    , url
    -- URLのパスやGETパラメータのid値を抽出する
    -- ■ PostgresQLの場合、substring関数と正規表現を用いる
    , substring(url from '//[^/]+([^?#]+)') AS path 
    , substring(url from 'id=([^&]*)') AS id
    -- ■ Redshiftの場合、regexp_substr関数とregexP_replace関数を組み合わせる
    -- , regexp_replace(regexp_substr(url, '//[^/]+[^?#]+*), '//[^/]+*, "*) AS path
    -- , regexp_replace(regexp_substr(url, 'id=[^&]*'), 'id=', '') AS id
    -- ■ BigQueryの場合、正規表現にregexp_extract関数を用いる
    -- , regexp_extract (url, '//[^/]+([^?#]+)') AS path
    -- , regexp_extract(url, 'id=([^&]*)') AS id
    -- ■ Hive.SparksQLの場合、parse_ur1関数でURLのパス部分やクエリバラメータ部分の値を抽出する
    -- , parse_url(url, 'PATH') AS path
    -- , parse_urI(url, 'QUERY', 'id') AS id
FROM access_log
