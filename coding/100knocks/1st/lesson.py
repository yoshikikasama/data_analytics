import pandas as pd


def main():
    customer_master = pd.read_csv('files/customer_master.csv')
    # print(customer_master.head())
    item_master = pd.read_csv('files/item_master.csv')
    transaction_1 = pd.read_csv('files/transaction_1.csv')
    transaction_2 = pd.read_csv('files/transaction_2.csv')
    transaction_detail_1 = pd.read_csv('files/transaction_detail_1.csv')
    transaction_detail_2 = pd.read_csv('files/transaction_detail_2.csv')

    # データの結合
    transaction = pd.concat([transaction_1, transaction_2], ignore_index=True)
    transaction_detail = pd.concat(
        [transaction_detail_1, transaction_detail_2], ignore_index=True)
    # print(transaction)
    # transaction_detailを軸にjoin
    join_data = pd.merge(transaction_detail, transaction[['transaction_id', 'payment_date', 'customer_id']],
                         on='transaction_id', how='left')
    join_data = pd.merge(join_data, customer_master, on='customer_id', how='left')
    join_data = pd.merge(join_data, item_master, on='item_id', how='left')
    # print(join_data.columns)
    # priceカラムの作成
    join_data['price'] = join_data['quantity'] * join_data['item_price']
    # print(join_data)
    # 欠損値の有無確認
    # print(join_data.isnull().sum())
    # 各種統計量の出力
    # print(join_data.describe())
    # datetime型に変更
    join_data['payment_date'] = pd.to_datetime(join_data['payment_date'])
    join_data['payment_month'] = join_data['payment_date'].dt.strftime('%Y%m')
    # print(join_data[['payment_date', 'payment_month']].head())
    # 月別売上の集計
    print(join_data.groupby('payment_month').sum()['price'])
    # 月別商品別に合計金額、数量の集計
    print(join_data.groupby(['payment_month', 'item_name']).sum()[['price', 'quantity']])


if __name__ == '__main__':
    main()
