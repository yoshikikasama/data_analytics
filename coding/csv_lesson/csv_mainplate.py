# 編集したいファイル（元ファイル）を開く
file = open("files/customer.csv", "r")
# 書き出し用のファイルを開く
out_file = open("files/output.csv", "w")

# 書き出し用ファイルのヘッダーを記述
out_file.write("ID,姓名,住所,電話番号\n")

# 元ファイルのヘッダーをreadlineメソッドで１行飛ばす
file.readline()
# 元ファイルのレコード部分をreadlinesメソッドで全行を読み取る
lines = file.readlines()
print(lines)
# for文で1行ずつ取得
for line in lines:
    # 改行コードをブランクに置換
    line = line.replace("\n","")
    # カンマ区切りでリストに変換する
    line = line.split(",")
    # 変換後のカンマ区切りの雛形を作り、変換処理した値を入れ込む
    row = f"{line[0]},{line[1] + '　' + line[2]},{line[3]},{line[4].replace('-','')}\n"
    # 書き出し用のファイルに出力
    out_file.write(row)

# ２つのファイルを閉じる
file.close()
out_file.close()