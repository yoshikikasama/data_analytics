-- リストの最初の非 NULL 値を返します。非 NULL 値がない場合は、NULL を返します。
-- つまり、欠損値(NULL)にデフォルト値を指定することができます。
-- 例
-- SELECT COALESCE(`office`.`locale`, `office`.name`, `リモート勤務`);
-- 上記のクエリを例にすると...。
-- office.locale(オフィスの場所)を出力。
-- office.localeが空の場合、office.name(オフィス名)を出力。
-- office.nameが空の場合、リモート勤務と出力します。

SELECT
    purchase_id
    , amount
    , coupon
    , amount - coupon as discount_amount_1
    , amount - COALESCE(coupon, 0) as discount_amount_2
from purchase_log_with_coupon
